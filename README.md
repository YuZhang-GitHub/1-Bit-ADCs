# Deep Learning for Massive MIMO with 1-Bit ADCs: When More Antennas Need Less Pilots
This is a MATLAB code package related to the following article:
# Abstract of the Article

# How to regenerate Figure 3?
1. Create two empty folders at the same directory as the downloaded codes and name them "**Networks**" and "**Data**" respectively. These two folders are used to store trained networks and necessary data that will be used to evaluate the performance.
2. Open the file `main.m` and execute it, which will call `oneBitDataPrep.m`, `buildNet.m` and `nmseReg.m` automatically.
3. `Raw_Data_BS32_2p4GHz_1Path.mat` and `pilot.mat` are two datasets that will also be used by `main.m`.
4. When `main.m` finishes, open `Fig3_Generator.m` and execute it, which will give Figure 3 as result.

![Figure3](https://github.com/YuZhang-GitHub/1-Bit-ADCs/blob/master/SNR.png)

If you have any problems with generating the figure, please contact [Yu Zhang](https://sites.google.com/view/yuzhangmatrix).

# License and Referencing
