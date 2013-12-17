# Calculates the (Averaged) Mean Square Error value of the specific type-principle test set.
#
# Input:
#   type		- The index of which type to get the AMSE of. (1-3)
#   principles	- The index of which principle to get the AMSE of. (1-6)
#
# Output:
#   AMSE 		- The (Averaged) Mean Square Error value of the chosen type-principle test set.
#
# Created by: Henrik
#
# Used in: C.d
#
#   ******************************************************************
#   **** BE SURE TO ADDPATH ==> 'inst' BEFORE USING THIS FUNCTION ****
#   ******************************************************************
#   *   octave:> addpath('inst');                                    *
#   ******************************************************************

function AMSE = mseOfTypeAndPrinciple(type, principle);

types = ["Comb"; "Pos"; "Rot"];
principles = ["HipInit"; "OpposRec"; "ShoulderDown"; "SpiralTrans"; "WCAlign"; "WESAlign"];

allX = dlmread(strcat('TrainingSet/', types(type, :), '/', principles(principle, :), '/x.txt'));
allY = dlmread(strcat('TrainingSet/', types(type, :), '/', principles(principle, :), '/y.txt'));

testSize=10;
testX = allX(:, 1:testSize);
testY = allY(:, 1:testSize);
trainX = allX(:, (testSize+1):45);
trainY = allY(:, (testSize+1):45);

total = 0;
runs = 10;
for i = 1:runs
	[scoreNN, cMean, cStd] = trainNN(trainX, trainY);
	testX_std = trastd(testX, cMean, cStd);
	simY = sim(scoreNN, testX_std);

	diffY = testY - simY;
	MSE = sum(diffY .^ 2) / length(testY);
	total += MSE;
end;

AMSE = total / runs;