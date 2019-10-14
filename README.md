# Deep Learning for Massive MIMO with 1-Bit ADCs: When More Antennas Need Less Pilots
This is a MATLAB code package related to the following article:
# Abstract of the Article

# How to regenerate Figure 3?
1. Create two empty folders at the same directory as the downloaded codes and name them "**Networks**" and "**Data**" respectively. These two folders will be used to store trained networks and necessary data that will be used to evaluate the performance.
2. Open the file `main.m` and execute it, which will call `oneBitDataPrep.m`, `buildNet.m` and `nmseReg.m` automatically.
3. The script adopts the publicly available parameterized [DeepMIMO dataset](http://deepmimo.net/ray_tracing.html?i=1) published for deep learning applications in mmWave and massive MIMO systems. The 'I1_2p4' scenario is adopted for this figure.
4. `Raw_Data_BS32_2p4GHz_1Path.mat` is generated based on 'I1_2p4' scenario and will also be used by `main.m`.
5. When `main.m` finishes, open `Fig3_Generator.m` and execute it, which will give Figure 3 as result.

![Figure3](https://github.com/YuZhang-GitHub/1-Bit-ADCs/blob/master/SNR.png)

If you have any problems with generating the figure, please contact [Yu Zhang](https://sites.google.com/view/yuzhangmatrix).

# License and Referencing
This code package is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0/). If you in any way use this code for research that results in publications, please cite our original article:
> Y. Zhang, M. Alrabeiah, and A. Alkhateeb, “Deep Learning for Massive MIMO with 1-Bit ADCs: When More Antennas Need Less Pilots,”
