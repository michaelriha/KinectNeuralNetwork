# trains NN for the given trainX and trainY
#
# Input:
#   trainX - matrix were each colom is the input vector for one training set
#   trainY - row vector for where each element is the output value for one training set
#
# Output:
#   scoreNN - the trained NN
#   cMean   - constant needed to standardize future input vector
#   cStd    - another constant needed to standardize future input vector
#
#
#   How to use the Output to simulate the trained scoreNN:
#
#     [scoreNN, cMean, cStd] = trainNN(trainX, trainY);
#     testX_std = trastd(testX, cMean, cStd);
#     simY = sim(scoreNN, testX_std);
#     # simY now containes the output prodused by the scoreNN 
#
#   ******************************************************************
#   **** BE SURE TO ADDPATH ==> 'inst' BEFORE USING THIS FUNCTION ****
#   ******************************************************************
#   *   octave:> addpath('inst');                                    *
#   ******************************************************************



function [scoreNN, cMean, cStd] = train_test_NN(trainX, trainY);

# 01 pre-standardize trainX
[trainX_prestd, cMean, cStd] = prestd(trainX);

# 02 set number of neurons (2n+1 rule) for hidden and output layers
nHiddenNeurons = 2*length(trainX(:,1))+1;
nOutputNeurons = 1;

# 03 construct min and max matrix of pre-std data
Pr = [min(trainX_prestd')' max(trainX_prestd')'];

# 04 create a new multi-layer neuron network
newNN = newff(Pr, [nHiddenNeurons, nOutputNeurons]);

# 05 train the NN on input and output
scoreNN = train(newNN, trainX_prestd, trainY);






# 09 standardize testX
# testX_std = trastd(testX, cMean, cStd);
# 10 get the output
# simY = sim(scoreNN, testX_std);
# 12 get the Y difference of each component;
# diffY =testY - simY;
# 13 calculate MSE
# MSE = sum(diffY .^ 2) / length(testY);
