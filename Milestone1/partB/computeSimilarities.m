# computes the similarity scores of all joint data contaied in 
# inputDirName and comcates it with the joint data of masterDirectory
#
# Input:
# inputDirName - path to the input directory wich contains everyones parsed joint data
#                (produced by parseMotionData.py)
# masterDirectory - path to masters directory which contains the parsed joint data of
#                   masters motion
#
# Output:
# A directory named 'SimilarityScores' which contains everyones similarity scores
#
#
# EXAMPLE USAGE:
#   octave> computeSimilarities('Output', 'Output/third_Steven-s3_u0'); 
#
 
function computeSimilarities(inputDirName, masterDirectory);

# prepare masters data that we are comparing against
# get list of all joint files in masters directory
fileList = readdir(masterDirectory);
# loop through each joint file (starts at 3 since fileList contains './' and '../' in index 1 and 2)
for (i = 3:length(fileList))
  fileName = fileList{i,1};
  v = extractVector([masterDirectory, '/', fileName]);
  masterData(i,:) = v;
end;

# dir name to store the output
OUTPUT_DIR_NAME = 'SimilarityScores';
# make that directory
confirm_recursive_rmdir(0, 'local');
rmdir(OUTPUT_DIR_NAME, 's');
mkdir(OUTPUT_DIR_NAME);

# get list of directories inside inputDirName
dirList = readdir(inputDirName);

# loop through each individual directory (starts at 3 since dirList contains './' and '../' in index 1 and 2)
for (i = 3:length(dirList))
  
  # get dir name
  dirName = dirList{i,1};
  
  # get list of all joint files
  fileList = readdir([inputDirName, '/', dirName]);
  
  # loop through each joint file (starts at 3 since fileList contains './' and '../' in index 1 and 2)
  for (j = 3:length(fileList))
  
    # get the file name
    fileName = fileList{j,1};

    # extract the vector from the file
    v = extractVector([inputDirName, '/', dirName, '/', fileName]);

    # calculate the similarity
    similarity = calcSimilarity(v, masterData(j,:));

    # append to output
    output{j-2, 1} = fileName;
    output{j-2, 2} = similarity;

  end;

  # save output to file
  fid = fopen([OUTPUT_DIR_NAME, '/', dirName], 'w');
  for (k = 1:length(output))
    fprintf(fid, '%s %s\n', output{k,1}, num2str(output{k,2}));
  end;
  fclose(fid);

end;

