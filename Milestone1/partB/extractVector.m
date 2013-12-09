# extracts vector from file specified by filePath
# input :
# filePath - path to file that contains vector (sequence of numbers)
# output :
# vOut - resulting vector

function vOut = extractVector(filePath);

vOut = dlmread(filePath ,' ');
