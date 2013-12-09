# plots vector contained in specified file by filepath
# param: filepath - file path in string format 

function A3Test(filepath);

# extract data
data = dlmread(filepath ,' ');
x = 0:length(data)-1;

# plot it
plot(x, data); hold on;
title(['Source: ', filepath]);
xlabel('capture');
plot(x, data, 'rx');
hold off;
