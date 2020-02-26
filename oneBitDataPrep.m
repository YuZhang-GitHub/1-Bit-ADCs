function [dataPrep, options] = oneBitDataPrep(channel, options)

% Note: channel is a struct with fields train_ch and val_ch,
%       both of which are 3D array with dimensions (#antenna@BS, #subcarriers, #users)

dataPrep = struct();

%% Raw data import
train_ch = channel.train_ch;
val_ch = channel.val_ch;

%% Generating pilot signal x
disp('Track: generating pilot signal')
pilotSig = options.pilot{1, options.pilotIdx}; % column vector

%% Noise power calculation
Pr_avg = mean(abs(train_ch(:)).^2);
SNR_dB = options.SNR_dB;
SNR    = 10^(.1*SNR_dB);
Pn     = (Pr_avg/SNR)/2;

%% Generating training dataset
disp('Track: generating training dataset')

inputDim = 2*prod(options.antDim)*options.pilotSize;
rawTrainInput = zeros(inputDim, options.numTrSamples); % need add antenna number in options
for ii = 1:options.numTrSamples
    rec = train_ch(:,options.subcarrier,ii);
    rec = rec*pilotSig.';
    rec = rec + sqrt(Pn)*randn(size(rec,1), size(rec,2)) + 1i*sqrt(Pn)*randn(size(rec,1), size(rec,2)); % Add noise
    recFlattened = reshape( rec, [prod(options.antDim)*options.pilotSize, 1] );
    rawTrainInput(:,ii) = [sign(real(recFlattened)); sign(imag(recFlattened))];
end
trainInput = reshape(rawTrainInput, [1, 1, inputDim, options.numTrSamples]); % Convert into the MATLAB format

trainTarget = zeros(options.numTrSamples, 2*prod(options.antDim));
for ii = 1:options.numTrSamples
    iitrain_ch = train_ch(:,options.subcarrier,ii);
    trainTarget(ii,:) = [real(iitrain_ch(:).'), imag(iitrain_ch(:).')];
end

dataPrep.train = cell(2,1);
dataPrep.train{1,1} = trainInput;
dataPrep.train{2,1} = trainTarget;

%% Generating validation dataset
disp('Track: generating validation dataset')

rawValInput = zeros(inputDim, options.numValSamples);
for ii = 1:options.numValSamples
    rec = val_ch(:,options.subcarrier,ii);
    rec = rec*pilotSig.';
    rec = rec + sqrt(Pn)*randn(size(rec,1), size(rec,2)) + 1i*sqrt(Pn)*randn(size(rec,1), size(rec,2)); % Add noise
    recFlattened = reshape( rec, [prod(options.antDim)*options.pilotSize, 1] );
    rawValInput(:,ii) = [sign(real(recFlattened)); sign(imag(recFlattened))];
end
valInput = reshape(rawValInput, [1, 1, inputDim, options.numValSamples]); % Convert into the MATLAB format

valTarget = zeros(options.numValSamples, 2*prod(options.antDim));
for ii = 1:options.numValSamples
    iival_ch = val_ch(:,options.subcarrier,ii);
    valTarget(ii,:) = [real(iival_ch(:).'), imag(iival_ch(:).')];
end

dataPrep.val = cell(2,1);
dataPrep.val{1,1} = valInput;
dataPrep.val{2,1} = valTarget;

end
