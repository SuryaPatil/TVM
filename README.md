# Executing BERT model as TVM object

The purpose of this project is to explore how one can convert a single-layered BERT model into Apache TVM’s intermediate representation (IR) and subsequently transform this IR into an executable. Below are instructions on how to use the above two source files to accomplish this task.


## Installing a Python package manager

Use a package manager, such as pip or conda, to install the necessary dependencies in a virtual environment. I recommend using conda: https://conda.io/projects/conda/en/latest/user-guide/install/index.html.

## Installing TVM

Install the latest version of TVM: https://tvm.apache.org/docs/install/from_source.html

## Create virtual environment with python 3.8

Create a virtual environment using the package manager chosen in step 1. For example, if you are using conda as your package manager, enter the command 
```bash
conda create -n myenv python=3.8
```
in your terminal. 

Activate the environment with the command

```bash
conda activate myenv
```
## Install the necessary dependencies 
In the virtual environment, install the necessary dependencies. If you are using conda, run each of the following in your terminal:
```bash
conda install pytorch torchvision torchaudio cudatoolkit=10.2 -c pytorch
```
```bash
conda install -c huggingface transformers
```
```bash
conda install -c conda-forge onnx
```
```bash
conda install numpy
```
If you are using a different package manager, install the dependencies using that package manager.
Also make sure to install the dependencies mentioned at the bottom of the TVM installation instructions: https://tvm.apache.org/docs/install/from_source.html
These dependencies include typing-extensions, psutil, and scipy.

## Configure and export a single-layered BERT model to ONNX

Navigate to the directory in which TVM is installed. Then, navigate to the python subdirectory:
```bash
cd python
```
In this directory, create a new ```.py``` file. In this new file, copy and paste the contents of ```export-bert```. Run this file on the command line:
```python <filename1>.py```

Now, in your current directory, you should see a file named ```single-layer.onnx```. 

## Load the single-layered BERT model and run the graph
In the current directory  create a new ```.py``` file. In this new file, copy and paste the contents of ```load-onnx```. Run this file on the command line:
```python <filename2>.py```

After running this command, you have successfully converted a single-layered BERT model to TVM format and ran an executable version of the model. 
