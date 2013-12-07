# Parses the files in SimilarityScores to generate an importable matrix for
# Octave/Matlab. The scores for each joint are averaged together to reduce
# the number of inputs to the Neural Network. The score is then added as the
# last column of the matrix.
#
# The data in similarityScores was culled so that only the 2nd and 4th punch
# data remains (since those were the ones scored, this should reduce error)
#
# Format is like this, and is output in octave matrix data format
#            J1   J2 ...  J24 JudgeScore
# P1_Punch2  Avg  Avg ... Avg Score
# P1_Punch4      ...
# P2_Punch2
# ...
#
# Written by Michael Riha 12/7/13 for CS156 Artificial Intelligence at SJSU

import os

inputDir = "SimilarityScores"
output = "kinectMatrixData.txt"
judgeScoreName = "judge_score.txt"
jointsRecorded = 24
paramsRecorded = 9

# Dictionary mapping names to judge scores
judgeScores = {}
judgeScoreFile = open(judgeScoreName)
for line in judgeScoreFile:
    [name, scores] = line.split()
    judgeScores[name] = scores.split(",")

# Open output file for writing and write the header
outputFile = open(output, 'w')
outputFile.write("# Created by Michael's awesome python script\n")
outputFile.write("# name: mData\n")
outputFile.write("# rows: " + str(len(os.listdir(inputDir))) + "\n")
outputFile.write("# columns: " + str(jointsRecorded + 1) + "\n")

for root, dirs, files in os.walk(inputDir):
    for f in files:
        simScores = open(os.path.join(root, f))   

        # Initialize array for each joint's similarity sum, +1 for the score
        outData = []
        for i in range(jointsRecorded + 1):
            outData.append(0)

        # Add all the scores for eacah joint
        for line in simScores:
            [jointData, simScore] = line.split()

            # Find end index of the joint number
            endIndex = 0
            for char in jointData[1:]:
                endIndex += 1
                if not char.isdigit():
                    break    
            outData[int(jointData[1:endIndex])-1] += float(simScore)
            
        # Average the joint similarities and convert float to str
        for i in range(jointsRecorded):
            outData[i] = str(outData[i] / paramsRecorded)

        # Find the matching score in the scores file
        name = f.split("_")[1]
        name = name[:name.find("-")]
        punchNum = 1 if f[1] == "2" else 2             
        outData[-1] = str(judgeScores[name][punchNum-1]) \
                    if name.lower() != "steven" else "10.0"
        outputFile.write(' '.join(outData) + "\n")

outputFile.close()
