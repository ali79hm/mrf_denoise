# mrf_denoise
## what is it?
by this verilog code you can denoise noisy pictures with hardware
## how use it?
there are 6 folders in this repository 
data folder contain pictures and datas
DataGenerator folder contain python files that converts picture to binary code to be undrestandable for hardware
ReferenceModel and TestBench are both do same thing but ReferenceModel is python files and its a software denoise but TestBench is in verlog and its a hardware denoise
ResultsChecker folder contains a python file that checks and plot denosied file
## before runing python files
```shell
pip install numpy
pip install image
pip3 install -U matplotlib
```
