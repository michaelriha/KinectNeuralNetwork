# calculates similarity of two vector using dtw and vertical normalization
# input :
# v1, v2 - vector1, vector2
# output : 
# sim - similarity where 0 is the best score possible; larger the worse

function sim = calcSimilarity(v1, v2);

sim = dtw(normalize(v1,[0,100]), normalize(v2,[0,100]));
