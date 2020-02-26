%===============================================================%
% main function for research:
% Deep Learning Based 1-Bit ADCs Channel Estimation
% School of ECEE, Arizona State University
% Tempe, AZ, USA
%===============================================================%

clc
clear
close all

%% Basic settings
options = struct();
options.inputType = 'Deep1bitADC';
options.netType = 'Plain';
options.allPilot = 100;
options.pilotList = [2 5 10];
options.p_num = size(options.pilotList,2);
options.numOfSub = 1;
options.subcarrier = 1;
options.bandWidth = 0.01; % unit: GHz
options.SNR_dB = 0; % unit: dB
options.rawDataFile = ...
    './Raw_Data_BS32_2p4GHz_1Path.mat'; % Path to dataset
options.netSaveDir = 'Networks/'; % Path to save trained network
options.varSaveDir = 'Data/'; % Path to save important variables

options.learnRateSch = 100;
options.maxNumEpochs = 100;

options.ch = [2 3 4 5 6 7 10 20 30 50 70 100];
options.ch_num = size(options.ch,2);
options.antDimCodebook = zeros(options.ch_num,3);
for i = 1:options.ch_num
    options.antDimCodebook(i,:) = [1, options.ch(i), 1]; % setting patterns
end

%% Generating pilots according to Proposition 1
options.pilot = uniformPilotsGen(options.pilotList);

%% Output data
R_NMSE = zeros(options.p_num, options.ch_num); % NMSE performance on validation dataset

%% Generating shuffled the channels h and locations

load(options.rawDataFile); % loading data, called dataset, which is a struct
disp('Track: loading completes!')

options.numOfSamples = size(dataset.channels,3); % A user (location) is a sample point and they all use same pilot.
shuffle_ind = randperm(options.numOfSamples);
options.shuffle_ind = shuffle_ind;
dataset.channel = dataset.channels(:,:,shuffle_ind); % Since #subcarriers is 1, channel is a vector.

%% Split data
trRatio = 0.7;
options.numTrSamples = floor( trRatio*options.numOfSamples );
options.numValSamples = options.numOfSamples - options.numTrSamples;
dataset.train_ch = dataset.channel(:,:,1:options.numTrSamples);
dataset.val_ch = dataset.channel(:,:,options.numTrSamples+1:end);

%% Data normalization:
disp('Track: data normalization')
options.max_abs = max( abs(dataset.train_ch(:)) );
dataset.train_ch = dataset.train_ch/options.max_abs; % Normalized training
dataset.val_ch = dataset.val_ch/options.max_abs; % Normalized validation (based on training dataset)

%% Sweeping over different pilot size 
for j = 1:options.p_num
    
    % sweeping over antenna number M
    for i = 1:options.ch_num
        
        options.antDim = options.antDimCodebook(i,:); % setting antenna number
        options.pilotSize = options.pilotList(j);
        options.pilotIdx = j;
        
        options.learningRate = 1e-4; % initial learning rate
        options.dropFactor = 0.1; % factor for dropping the learning rate
        options.weightDecay = 1e-5;
        options.batchSize = 512;
        options.valFreq = 500; % frequency of network validation in number of iterations (mini-batches)
        
        options.inputSize = [1, 1, prod(options.antDim)*options.pilotSize*2];
        options.outputSize = 2*prod(options.antDim);
        
        truncChannels.train_ch = dataset.train_ch(1:options.ch(i),:,:); % always update this
        truncChannels.val_ch = dataset.val_ch(1:options.ch(i),:,:);
        % no need to touch dataset.userLoc, since no antenna info contained
        
        [dataPrep,options] = oneBitDataPrep(truncChannels, options);
        % note: the output dataset is different from input dataset
        
        %% Network Construction:
        disp('Track: network construction section begins!')
        
        net = buildNet(options.inputSize, options.outputSize, options);
        
        %% Network training:
        disp('Track: network training section begins!')
        
        trainOpt = trainingOptions('adam', ...
            'InitialLearnRate',options.learningRate, ...
            'LearnRateSchedule','piecewise', ...
            'LearnRateDropFactor',options.dropFactor, ...
            'LearnRateDropPeriod',options.learnRateSch, ...
            'L2Regularization',options.weightDecay, ...
            'MaxEpochs',options.maxNumEpochs, ...
            'MiniBatchSize',options.batchSize, ...
            'Shuffle','every-epoch', ...
            'ValidationData',dataPrep.val, ...
            'ValidationFrequency',options.valFreq, ...
            'ExecutionEnvironment','gpu', ...
            'ValidationPatience', 10, ... % Disables automatic training break-off
            'Plots','none');
        
        gpuDevice(1)
        [trainedNet, trainingInfo] = trainNetwork(dataPrep.train{1,:}, dataPrep.train{2,:}, net, trainOpt);
        save([options.netSaveDir,'net_ant=',num2str(options.ch(i)),'_pilot=',num2str(options.pilotSize)], 'trainedNet')
        
        % show NMSE on validation dataset
        nanLoc = isnan(trainingInfo.ValidationLoss);
        valNMSE = trainingInfo.ValidationLoss(~nanLoc);
        options.valNMSE = valNMSE;
        R_NMSE(j, i) = options.valNMSE(end);
        
        %% Performance evaluation
        % Achivable Rate over M
        disp('Track: performance evaluation section begins!')
        
        valInput = dataPrep.val{1,1}; % input
        valTarget = dataPrep.val{2,1}; % target
        valNum = size(valInput, 4);
        
        Ch_pred_raw = trainedNet.predict(valInput);
        half = size(Ch_pred_raw, 2)/2;
        Ch_pred = transpose( complex(Ch_pred_raw(:,1:half), Ch_pred_raw(:,half+1:end)) ); % 2D: (#ant, valNum)
        Ch_pred_norm = sum(abs(Ch_pred).^2, 1).^(1/2); % row vector, summation is over column
        Ch_target = transpose( complex(valTarget(:,1:half), valTarget(:,half+1:end)) ); % 2D: (#ant, valNum)
        
        save([options.varSaveDir,'antNum=',num2str(options.ch(i)),'_pilots=',num2str(options.pilotSize)], 'dataset', 'Ch_target', 'Ch_pred', 'options', '-v7.3')
        
    end % end of sweeping over antenna number
    
end % end of sweeping over pilot size

%% Save NMSE performance for analysis
save([options.varSaveDir,'FinalResults'], 'R_NMSE')
