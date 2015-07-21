function [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,numberOfTwins)
% TODO: write documentation for generateTwins() function [Issue: https://github.com/afcuttin/irsa/issues/1]

rafRow = cell(1,randomAccessFrameLength);
pcktTwins = randperm(randomAccessFrameLength,numberOfTwins);
for i = 1:length(pcktTwins)
	twinsPointers = pcktTwins;
	twinsPointers(i) = [];
	rafRow{pcktTwins(i)} = twinsPointers;
end