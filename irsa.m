function [loadNorm,throughputNorm,packetLossRatio] = irsa(sourceNumber,randomAccessFrameLength,packetReadyProb,maxRepetitionRate,simulationTime)
% function [normalized network load,normalized network throughput,packet loss ratio] = sic(source number,random access frame length, packet ready probability, maximum repetition rate, simulation time)

% check for errors
% TODO: check variable value - randomAccessFrameLength must be a positive integer and greater than maxRepetitionRate [Issue: https://github.com/afcuttin/irsa/issues/4]
% TODO: check variable value - sourceNumber must be a positive integer [Issue: https://github.com/afcuttin/irsa/issues/6]
% TODO: check variable value - simulationTime must be a positive integer [Issue: https://github.com/afcuttin/irsa/issues/5]
% TODO: check variable value - packet ready probability must be a double between 0 and 1 [Issue: https://github.com/afcuttin/irsa/issues/2]
% TODO: check variable value - maxRepetitionRate shall be one of the following values: 4, 5, 6, 8, 16 [Issue: https://github.com/afcuttin/irsa/issues/14]

ackdPacketCount = 0;
pcktTransmissionAttempts = 0;
pcktCollisionCount = 0;
sourceStatus = zeros(1,sourceNumber);
sourceBackoff = zeros(1,sourceNumber);
% legit source statuses are always non-negative integers and equal to:
% 0: source has no packet ready to be transmitted (is idle)
% 1: source has a packet ready to be transmitted, either because new data must be sent or a previously collided packet has waited the backoff time
% 2: source is backlogged due to previous packets collision
pcktGenerationTimestamp = zeros(1,sourceNumber);
currentRAF = 0;

while currentRAF < simulationTime
    randomAccessFrame = zeros(sourceNumber,randomAccessFrameLength); % later on referred to as RAF
    twinsOverhead = cell(sourceNumber,randomAccessFrameLength);
    currentRAF = currentRAF + 1;

    for eachSource1 = 1:sourceNumber % create the RAF
        if sourceStatus(1,eachSource1) == 0 && rand(1) <= packetReadyProb % new packet
            sourceStatus(1,eachSource1) = 1;
            pcktGenerationTimestamp(1,eachSource1) = currentRAF;
            pcktRepetitionExp = rand(1);
            switch maxRepetitionRate
                case 4
                    if pcktRepetitionExp <= 0.5102
                        % genera 2 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,2);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    elseif pcktRepetitionExp <= (0.5102 + 0.4898)
                        % genera 4 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,4);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    end
                case 5
                    if pcktRepetitionExp <= 0.5631
                        % genera 2 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,2);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    elseif pcktRepetitionExp <= (0.5631 + 0.0436)
                        % genera 3 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,4);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    elseif pcktRepetitionExp <= (0.5631 + 0.0436 + 0.3933)
                        % genera 5 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,5);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    end
                case 6
                    if pcktRepetitionExp <= 0.5465
                        % genera 2 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,2);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    elseif pcktRepetitionExp <= (0.5465 + 0.1623)
                        % genera 3 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,3);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    elseif pcktRepetitionExp <= (0.5465 + 0.1623 + 0.2912)
                        % genera 6 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,6);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    end
                case 8
                    if pcktRepetitionExp <= 0.5
                        % genera 2 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,2);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    elseif pcktRepetitionExp <= (0.5 + 0.28)
                        % genera 3 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,3);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    elseif pcktRepetitionExp <= (0.5 + 0.28 + 0.22)
                        % genera 8 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,8);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    end
                otherwise % case 16
                    if pcktRepetitionExp <= 0.4977
                        % genera 2 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,2);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207)
                        % genera 3 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,3);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381)
                        % genera 4 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,4);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381 + 0.0756)
                        % genera 5 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,5);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381 + 0.0756 + 0.0398)
                        % genera 6 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,6);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381 + 0.0756 + 0.0398 + 0.0009)
                        % genera 7 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,7);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381 + 0.0756 + 0.0398 + 0.0009 + 0.0088)
                        % genera 8 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,8);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381 + 0.0756 + 0.0398 + 0.0009 + 0.0088 + 0.0068)
                        % genera 9 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,9);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381 + 0.0756 + 0.0398 + 0.0009 + 0.0088 + 0.0068 + 0.0030)
                        % genera 11 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,11);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381 + 0.0756 + 0.0398 + 0.0009 + 0.0088 + 0.0068 + 0.0030 + 0.0429)
                        % genera 14 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,14);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381 + 0.0756 + 0.0398 + 0.0009 + 0.0088 + 0.0068 + 0.0030 + 0.0429 + 0.0081)
                        % genera 15 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,15);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381 + 0.0756 + 0.0398 + 0.0009 + 0.0088 + 0.0068 + 0.0030 + 0.0429 + 0.0081 + 0.0576)
                        % genera 16 repliche
                        [pcktTwins,rafRow] = generateTwins(randomAccessFrameLength,16);
                        randomAccessFrame(eachSource1,pcktTwins) = 1;
                        twinsOverhead(eachSource1,:) = rafRow;
                    end
            end
        % elseif sourceStatus(1,eachSource1) == 1 % backlogged source
        %     firstReplicaSlot = randi(randomAccessFrameLength);
        %     secondReplicaSlot = randi(randomAccessFrameLength);
        %     while secondReplicaSlot == firstReplicaSlot
        %         secondReplicaSlot = randi(randomAccessFrameLength);
        %     end
        %     randomAccessFrame(eachSource1,firstReplicaSlot) = secondReplicaSlot;
        %     randomAccessFrame(eachSource1,secondReplicaSlot) = firstReplicaSlot;
        end
    end

    [sicRAF,sicCol,sicRow] = sic(randomAccessFrame,twinsOverhead); % do the Successive Interference Cancellation

    pcktTransmissionAttempts = pcktTransmissionAttempts + sum(sourceStatus == 1); % "the normalized MAC load G does not take into account the replicas" Casini et al., 2007, pag.1411; "The performance parameter is throughput (measured in useful packets received per slot) vs. load (measured in useful packets transmitted per slot" Casini et al., 2007, pag.1415
    ackdPacketCount = ackdPacketCount + numel(sicCol);

    sourcesReady = find(sourceStatus);
    sourcesCollided = setdiff(sourcesReady,sicRow);
    % if numel(sourcesCollided) > 0
    %     pcktCollisionCount = pcktCollisionCount + numel(sourcesCollided);
    %     sourceStatus(sourcesCollided) = 2;
    % end

    sourceStatus = sourceStatus - 1; % update sources statuses
    sourceStatus(sourceStatus < 0) = 0; % idle sources stay idle (see permitted statuses above)
end

loadNorm = pcktTransmissionAttempts / (simulationTime * randomAccessFrameLength);
throughputNorm = ackdPacketCount / (simulationTime * randomAccessFrameLength);
pcktCollisionProb = pcktCollisionCount / (simulationTime * randomAccessFrameLength);;
if pcktTransmissionAttempts ~= 0
    packetLossRatio = 1 - ackdPacketCount / pcktTransmissionAttempts;
elseif pcktTransmissionAttempts == 0 && ackdPacketCount == 0
    packetLossRatio = 0;
end