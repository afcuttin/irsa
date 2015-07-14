function [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,numberOfTwins,seed)
% TODO: write documentation for generateTwins() function [Issue: https://github.com/afcuttin/irsa/issues/1]

rafRow = cell(1,randomAccessFrameLength);
while length(seed) < numberOfTwins
    candidateSlot = randi(randomAccessFrameLength);
    while ismember(candidateSlot,seed)
        candidateSlot = randi(randomAccessFrameLength);
    end
    seed = [seed,candidateSlot];
end
pcktTwins = seed
for i = 1:length(pcktTwins)
	twinsPointers = setdiff(pcktTwins,pcktTwins(i))
	rafRow{pcktTwins(i)} = twinsPointers
end
rafRow
