# Calculates the (Averaged) Mean Square Error value of each of the principle training sets.
#
# Input:
#   num		- The index of which principle to get the AMSE of. (1-6)
#
# Output:
#   AMSE 	- The (Averaged) Mean Square Error value of the chosen training set.
#
# Created by: Henrik
#
# Used in: B (a. in particular)
#
#   ******************************************************************
#   **** BE SURE TO ADDPATH ==> 'inst' BEFORE USING THIS FUNCTION ****
#   ******************************************************************
#   *   octave:> addpath('inst');                                    *
#   ******************************************************************

function AMSE = calcTrainPrincipleAverageMSE(num);

principles = ["HipInit"; "OpposRec"; "ShoulderDown"; "SpiralTrans"; "WCAlign"; "WESAlign"];

allX = dlmread(strcat('TrainingSet/Comb/', principles(num, :), '/x.txt'));
allY = dlmread(strcat('TrainingSet/Comb/', principles(num, :), '/y.txt'));

total = 0;
runs = 10;
for i = 1:runs
	[scoreNN, cMean, cStd] = trainNN(allX, allY);
	testX_std = trastd(allX, cMean, cStd);
	simY = sim(scoreNN, testX_std);

	diffY = allY - simY;
	MSE = sum(diffY .^ 2) / length(allY);
	total += MSE;
end;

AMSE = total / runs;