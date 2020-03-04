function net = buildNet(inputSize, outputSize, options)
%==========================================================================
% buildNet constucts the deep neural network
%
%
%==========================================================================

switch options.netType
    case 'Plain'
        vecInput = imageInputLayer(inputSize, 'Name', 'input');
        fc1 = fullyConnectedLayer(8192,'Name','fc1');
        relu1 = reluLayer('Name','relu1');
        drop1 = dropoutLayer(0.02,'Name','drop1');
        fc2 = fullyConnectedLayer(8192,'Name','fc2');
        relu2 = reluLayer('Name','relu2');
        drop2 = dropoutLayer(0.02,'Name','drop2');
        fc3 = fullyConnectedLayer(outputSize, 'Name', 'fc3');
        regOutput = nmseReg('regOutput');

        layers = [...
            vecInput
            fc1
            relu1
            drop1
            fc2
            relu2
            drop2
            fc3
            regOutput];
        
        net = layerGraph(layers);
        
end
        
