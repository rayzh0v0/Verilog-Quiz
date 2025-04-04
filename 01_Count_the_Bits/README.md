# Count the Bits

## 题目介绍 Question Introduction
输入为 32bit 位宽的数据，统计 32bit 位中是 1 的个数？</br>
Enter 32bit wide data. Collect the number of 1 in 32bit bits.

## 参考解答 Refence Answer
使用4级加法器完成对于所有bit的计算</br>
Complete the calculation for all bits using a 4-level adder

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
===== Fixed test cases =====
VCD info: dumpfile top.vcd opened for output.
Test passed: Data=00000000, 1's count=0
Test passed: Data=ffffffff, 1's count=32
Test passed: Data=aaaaaaaa, 1's count=16

===== Random test cases =====
Test passed: Data=92153524, 1's count=12
Test passed: Data=40895e81, 1's count=11
Test passed: Data=0484d609, 1's count=10
Test passed: Data=31f05663, 1's count=15
Test passed: Data=86b97b0d, 1's count=17
Test passed: Data=c6df998d, 1's count=19
Test passed: Data=32c28465, 1's count=12
Test passed: Data=09375212, 1's count=12
Test passed: Data=80f3e301, 1's count=13
Test passed: Data=86d7cd0d, 1's count=17

All tests passed!
 ____   _    ____ ____  
|  _ \ / \  / ___/ ___| 
| |_) / _ \ \___ \___ \ 
|  __/ ___ \ ___) |__) |
|_| /_/   \_\____/____/ 

```