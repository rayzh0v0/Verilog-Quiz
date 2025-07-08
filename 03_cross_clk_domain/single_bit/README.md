# Cross clock domain

## 题目介绍 Question Introduction
给定一个初始时钟，请将该时钟进行3分频以及5分频。要求分频后，时钟的占空比为50%。</br>
Given an initial clock, please divide the clock into 3 and 5. The clock duty cycle should be 50%.

## 参考解答 Refence Answer
通过下降沿将时钟信号移动一个周期产生相位差，再相与实现分频</br>
By shifting the clock signal by one cycle through the falling edge, a phase difference is generated, and then performing an AND operation to achieve frequency division.</br>


## 工程使用方法 Project Use Method
工程使用Makefile进行编译，运行`make`即可</br>
Project compilation is performed using Makefile. Run `make` to compile and run the project.</br>
</br>
输入命令`make wave`通过gtkwave查看波形</br>
Input the command `make wave` to view the waveform through gtkwave</br>
</br>
输入`make help`命令可以查看更多可用的make命令</br>
Input the `make help` command to view more available make commands

## 运行结果 Run Result

```shell
Run for 1000ns

All tests passed!
 ____   _    ____ ____  
|  _ \ / \  / ___/ ___| 
| |_) / _ \ \___ \___ \ 
|  __/ ___ \ ___) |__) |
|_| /_/   \_\____/____/ 
top_tb.sv:141: $finish called at 1022000 (1ps)
```