import torch
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
# Load the traced model
model = torch.jit.load("traced_bert_model.pt")

# Set the model to evaluation mode
model.eval()

for p in model.parameters(): #  iterator over module parameters.
    p.requires_grad_(False)

shape_list = [('input 0', (1,5))]

mod_bert, params_bert = tvm.relay.frontend.pytorch.from_pytorch(model,
                        shape_list, default_dtype="float32")

print(type(mod_bert))