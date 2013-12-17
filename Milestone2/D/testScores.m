# Calculates judge-scores based on the various principles and their weights.
#
#
#
#
# Output:
#   totalScore	- The calculated judge-scores given by the similarity of the various principles.
#
# Created by: Henrik
#
# Used in: D
#
#   ******************************************************************
#   **** BE SURE TO ADDPATH ==> 'inst' BEFORE USING THIS FUNCTION ****
#   ******************************************************************
#   *   octave:> addpath('inst');                                    *
#   ******************************************************************

function totalScore = testScores();

principles = ["HipInit"; "OpposRec"; "ShoulderDown"; "SpiralTrans"; "WCAlign"; "WESAlign"];
principleMaxScore = [2 2 2 2 1 1];

testSize = 5;
totalScore = zeros(1, testSize);

for i = 1:6
	allX = dlmread(strcat('TrainingSet/Comb/', principles(i, :), '/x.txt'));
	allY = dlmread(strcat('TrainingSet/Comb/', principles(i, :), '/y.txt'));
	testX = allX(:, 1:testSize);
	trainX = allX(:, (testSize+1):45);
	trainY = allY(:, (testSize+1):45);

	[scoreNN, cMean, cStd] = trainNN(trainX, trainY);
	testX_std = trastd(testX, cMean, cStd);
	simY = sim(scoreNN, testX_std);

	totalScore = totalScore + simY * principleMaxScore(i) / 10;
end;