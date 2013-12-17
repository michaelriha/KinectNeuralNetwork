














#
#  Example:
#
#  Mat = [  1 2 3 4 
#           5 6 7 8
#           9 A B C
#           D E F G  
#           H I J K  ];
#
#  colSet = [1 3];
#
#  octave:> [xSet ySet] = getSelectedCol(colSet, Mat);
#
#   # selected columns (by colSet) of Mat transposed
#     xSet ===> [ 1 5 9 D H
#                 3 7 B F J ] 
#
#   # last column of Mat transposed
#     ySet ===> [ 4 8 C G K ]


function [xSet, ySet] = getSelectedCol(colSet,Mat);

[rowNum, colNum] = size(Mat);

ySet = Mat(:,colNum);
xSet = zeros(rowNum, length(colSet));

for i = 1 : length(colSet)
	xSet(:,i) = Mat(:,colSet(i));
endfor

xSet = xSet';
ySet = ySet';
