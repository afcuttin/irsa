function [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,numberOfTwins,seed)
% TODO: write documentation for generateTwins() function [Issue: https://github.com/afcuttin/irsa/issues/1]

rafRow = cell(1,randomAccessFrameLength);
while length(seed) < numberOfTwins
    candidateSlot = randi(randomAccessFrameLength);
    while ismember(candidateSlot,seed)
        candidateSlot = randi(randomAccessFrameLength);
    end
    seed = [seed,candidateSlot]; % TODO: The variable 'seed' appears to change size on every loop iteration. Consider preallocating for speed. [Issue: https://github.com/afcuttin/irsa/issues/8]
end
pcktTwins = seed;
for i = 1:length(pcktTwins)
	twinsPointers = setdiff(pcktTwins,pcktTwins(i)); % TODO: the setdiff function takes a lot of time; sorting pkctTwins could help? [Issue: https://github.com/afcuttin/irsa/issues/9]
	rafRow{pcktTwins(i)} = twinsPointers;
end
