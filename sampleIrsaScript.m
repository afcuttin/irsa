clear all;

sourceNumber = 200;
randomAccessFrameLength = 200; % Liva, 2011, pag. 482
simulationTime = 1e1; % total number of RAF
packetReadyProb = .5;
maxRepetitionRate = 8;

[loadNorm,throughputNorm,packetLossRatio] = irsa(sourceNumber,randomAccessFrameLength,packetReadyProb,maxRepetitionRate,simulationTime);

fprintf('\nNetwork load (G): %.3f,\nNetwork throughput (S): %.3f,\nPacket loss ratio: %.4f.\n',loadNorm,throughputNorm,packetLossRatio);
