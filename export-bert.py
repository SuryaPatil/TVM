import transformers

from transformers import BertModel, BertTokenizer, BertConfig
import numpy as np

import torch
import os
from tvm.contrib import graph_executor

import tvm
import tvm.relay
from tvm import relay, runtime
import sys

from transformers import BertModel, BertTokenizer, BertConfig
print(f"torch version: {torch.__version__}, tvm version: {tvm.__version__}, transformers version: {transformers.__version__}");
# Load original pretrained model
original_model = BertModel.from_pretrained("bert-base-uncased")

# Create new config with one layer and without pooling layer
config = BertConfig.from_pretrained("bert-base-uncased", num_hidden_layers=1, add_pooling_layer=False, return_dict=False)

# Create new model with one layer and without pooling layer
new_model = BertModel(config)

# Copy weights from original model to new model for the remaining layer
new_model.encoder.layer[0].load_state_dict(original_model.encoder.layer[0].state_dict())

# Disable gradient updates
for param in new_model.parameters():
    param.requires_grad = False

# Remember to put the model in eval mode if you're doing inference
new_model.eval()
print(new_model)
dummy_input = torch.rand(size = (1,5)).int()
print(type(dummy_input))
print(dummy_input.shape)
print(type(dummy_input.shape))
torch.onnx.export(new_model, dummy_input, "single-layer.onnx", verbose=True)