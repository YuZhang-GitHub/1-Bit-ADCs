# Deep Learning for Massive MIMO with 1-Bit ADCs: When More Antennas Need Fewer Pilots
This is the MATLAB codes related to the following article: Yu Zhang, Muhammad Alrabeiah, and Ahmed Alkhateeb, “[Deep Learning for Massive MIMO with 1-Bit ADCs: When More Antennas Need Fewer Pilots](https://arxiv.org/abs/1910.06960),” arXiv e-prints, p. arXiv:1910.06960, Oct 2019.
# Abstract of the Article
This paper considers uplink massive MIMO systems with 1-bit analog-to-digital converters (ADCs) and develops a deep-learning based channel estimation framework. In this framework, the prior channel estimation observations and deep neural network models are leveraged to learn the non-trivial mapping from quantized received measurements to channels. For that, we derive the sufficient length and structure of the pilot sequence to guarantee the existence of this mapping function. This leads to the interesting, and _counter-intuitive_, observation that when more antennas are employed by the massive MIMO base station, our proposed deep learning  approach achieves better channel estimation performance, for the same pilot sequence length. Equivalently, for the same channel estimation performance, this means that when more antennas are employed, fewer pilots are required. This observation is also analytically proved for some special channel models. Simulation results confirm our observations and show that more antennas lead to better channel estimation both in terms of the normalized mean squared error and the achievable signal-to-noise ratio per antenna.

# How to regenerate Figure 3 in [this](https://arxiv.org/abs/1910.06960) paper?
1. Download all the files of this repository.  
Update: Many people encountered and reported problems in downloading and using **Raw_Data_BS32_2p4GHz_1Path.mat**. Please use [this link](https://drive.google.com/file/d/1CXwReLlqdbiAk3xVxNFEBAq0poaN6CE6/view?usp=sharing) to download the data file.
2. Create two empty folders at the same directory as the downloaded codes and name them "**Networks**" and "**Data**" respectively. As the names indicate, "**Networks**" will store the trained neural networks and "**Data**" will store the predicted channels for evaluations.
3. Run `main.m` in MATLAB.
4. When `main.m` finishes, execute `Fig3_Generator.m`, which will give Figure 3 shown below as result.

![Figure3](https://github.com/YuZhang-GitHub/1-Bit-ADCs/blob/master/SNR.png)

If you have any problems with generating the figure, please contact [Yu Zhang](https://www.linkedin.com/in/yu-zhang-391275181/).

# License and Referencing
This code package is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0/). If you in any way use this code for research that results in publications, please cite our original article:
> Y. Zhang, M. Alrabeiah, and A. Alkhateeb, “[Deep Learning for Massive MIMO with 1-Bit ADCs: When More Antennas Need Fewer Pilots](https://arxiv.org/abs/1910.06960),” arXiv e-prints, p. arXiv:1910.06960, Oct 2019.
