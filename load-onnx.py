import onnx
import numpy as np
import tvm
from tvm import te
import tvm.relay as relay
from tvm.contrib.download import download_testdata
from tvm.contrib import graph_executor
# Load the ONNX model
model = onnx.load("single-layer.onnx")
#print(model)
print("model loaded")
# Check that the model is well formed
onnx.checker.check_model(model)
print("Checked model")
target = "llvm"
# Which device to run on. Should be one of tvm.cpu() or tvm.cuda().
dev = tvm.cpu()
input_name = "1"
shape_dict = {input_name: (1,5)}
mod, params = relay.frontend.from_onnx(model)

print(type(mod))

# The number of batches in an input.
batch_size = 1
# The length of each input sequence.
seq_len = 5

shape_dict = {"input_1": (batch_size, seq_len)}

def run_relay_graph(mod, params, shape_dict, target, dev):
    with relay.build_config(opt_level=3):
        lib = relay.build(mod, target=target, params=params)
        print(type(lib))
    input_shape = shape_dict["input_1"]
    dummy_data = np.random.uniform(size=input_shape, low=0, high=input_shape[1]).astype("int32")

    m = graph_executor.GraphModule(lib["default"](dev)) # Wrapper runtime module
    m.set_input(0, dummy_data) # Set inputs to the module
    m.run() # Run forward execution of the graph
    tvm_output = m.get_output(0) # Run graph up to node 0

    print(m.benchmark(dev, repeat=5, number=5))
    return m, tvm_output

exec, graph = run_relay_graph(mod, params, shape_dict, target, dev)

print(type(exec))

# Run the forward execution of the graph
exec.run()