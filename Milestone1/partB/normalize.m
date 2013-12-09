# normalizes input vector vIn to given range
#
# Input:
# vIn - input vector to be normalized
# range - range of the output vector 
#         (for example, range [0,1] will 
#         map minimum value of vIn to 0 and 
#         maximum value of vIn to 1; every other 
#         point betwee these range)
#
# Output:
# vOut - normalized vector

function vOut = normalize(vIn, range);

min = min(vIn);
max = max(vIn);
len = length(vIn);

r0 = range(1);
r1 = range(2);
d = max- min;

if d == 0,
  vOut = vIn;
else
  for i = 1:len,
    vOut(i) = vIn(i) - min;
    vOut(i) = vOut(i) * (r1/d); 
    vOut = vOut + r0;
  end;
end;
