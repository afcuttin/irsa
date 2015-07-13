clear all;
% TODO: evolve from script to function [Issue: https://github.com/afcuttin/crdsa/issues/8]
sourceNumber = 200;
randomAccessFrameLength = 100; % Casini et al., 2007, pag.1413
simulationTime = 1e4; % total number of RAF
packetReadyProb = 3.2988e-1;
maxRepetitionRate = 4;
% lossy = true;

% check for errors
% TODO: check variable value - randomAccessFrameLength must be a positive integer and greater than 1 [Issue: https://github.com/afcuttin/crdsa/issues/4]
% TODO: check variable value - sourceNumber must be a positive integer [Issue: https://github.com/afcuttin/crdsa/issues/1]
% TODO: check variable value - simulationTime must be a positive integer [Issue: https://github.com/afcuttin/crdsa/issues/2]
% TODO: check variable value - packet ready probability must be a double between 0 and 1 [Issue: https://github.com/afcuttin/crdsa/issues/5]

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
                    elseif pcktRepetitionExp <= (0.5102 + 0.4898)
                        % genera 4 repliche
                    end
                case 5
                    if pcktRepetitionExp <= 0.5631
                        % genera 2 repliche
                    elseif pcktRepetitionExp <= (0.5631 + 0.0436)
                        % genera 3 repliche
                    elseif pcktRepetitionExp <= (0.5631 + 0.0436 + 0.3933)
                        % genera 5 repliche
                    end
                case 6
                    if pcktRepetitionExp <= 0.5465
                        % genera 2 repliche
                    elseif pcktRepetitionExp <= (0.5465 + 0.1623)
                        % genera 3 repliche
                    elseif pcktRepetitionExp <= (0.5465 + 0.1623 + 0.2912)
                        % genera 6 repliche
                    end
                case 8
                    if pcktRepetitionExp <= 0.5
                        % genera 2 repliche
                    elseif pcktRepetitionExp <= (0.5 + 0.28)
                        % genera 3 repliche
                    elseif pcktRepetitionExp <= (0.5 + 0.28 + 0.22)
                        % genera 8 repliche
                    end
                otherwise % case 16
                    if pcktRepetitionExp <= 0.4977
                        % genera 2 repliche
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207)
                        % genera 3 repliche
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381)
                        % genera 4 repliche
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381 + 0.0756)
                        % genera 5 repliche
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381 + 0.0756 + 0.0398)
                        % genera 6 repliche
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381 + 0.0756 + 0.0398 + 0.0009)
                        % genera 7 repliche
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381 + 0.0756 + 0.0398 + 0.0009 + 0.0088)
                        % genera 8 repliche
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381 + 0.0756 + 0.0398 + 0.0009 + 0.0088 + 0.0068)
                        % genera 9 repliche
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381 + 0.0756 + 0.0398 + 0.0009 + 0.0088 + 0.0068 + 0.0030)
                        % genera 11 repliche
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381 + 0.0756 + 0.0398 + 0.0009 + 0.0088 + 0.0068 + 0.0030 + 0.0429)
                        % genera 14 repliche
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381 + 0.0756 + 0.0398 + 0.0009 + 0.0088 + 0.0068 + 0.0030 + 0.0429 + 0.0081)
                        % genera 15 repliche
                    elseif pcktRepetitionExp <= (0.4977 + 0.2207 + 0.0381 + 0.0756 + 0.0398 + 0.0009 + 0.0088 + 0.0068 + 0.0030 + 0.0429 + 0.0081 + 0.0576)
                        % genera 16 repliche
                    end
            end
            firstReplicaSlot = randi(randomAccessFrameLength);
            secondReplicaSlot = randi(randomAccessFrameLength);
            while secondReplicaSlot == firstReplicaSlot
                secondReplicaSlot = randi(randomAccessFrameLength);
        	end
            randomAccessFrame(eachSource1,firstReplicaSlot) = secondReplicaSlot;
            randomAccessFrame(eachSource1,secondReplicaSlot) = firstReplicaSlot;
        % elseif sourceStatus(1,eachSource1) == 1 % backlogged source TODO: add a conditional to disable/enable retransmission of collided packets [Issue: https://github.com/afcuttin/crdsa/issues/7]
        %     firstReplicaSlot = randi(randomAccessFrameLength);
        %     secondReplicaSlot = randi(randomAccessFrameLength);
        %     while secondReplicaSlot == firstReplicaSlot
        %         secondReplicaSlot = randi(randomAccessFrameLength);
        %     end
        %     randomAccessFrame(eachSource1,firstReplicaSlot) = secondReplicaSlot;
        %     randomAccessFrame(eachSource1,secondReplicaSlot) = firstReplicaSlot;
        end
    end

    acked_col=find(sum(randomAccessFrame>0)==1); % find slot indices of packets without collisions
    % TODO: the following lines should probably be included in the SIC funcion, so that only the acked_col parameter is to be passed as a function parameter [Issue: https://github.com/afcuttin/crdsa/issues/9]
    [row_c,col_c,twinSlotId] = find(randomAccessFrame);
    row=transpose(row_c);
    col=transpose(col_c);
    [~,col_ind]=ismember(acked_col,col);
    acked_row = row(col_ind); % find source indices of packets without collisions

    if numel(acked_col) > 0
        % TODO: add conditional in case twin packets do not collide in the RAF at all [Issue: https://github.com/afcuttin/crdsa/issues/3]
        % in this circumstance, there is no need to  perform SIC, because the number of the acknowledged packets is exaclty two times the number of active sources, thus saving computing time
        [sicRAF,sicCol,sicRow] = sic(randomAccessFrame,acked_col,acked_row); % do the Successive Interference Cancellation
    elseif numel(acked_col) == 0
        % sicRAF = randomAccessFrame;
        sicCol = [];
        sicRow = [];
    end

    pcktTransmissionAttempts = pcktTransmissionAttempts + sum(sourceStatus == 1); % "the normalized MAC load G does not take into account the replicas" Casini et al., 2007, pag.1411; "The performance parameter is throughput (measured in useful packets received per slot) vs. load (measured in useful packets transmitted per slot" Casini et al., 2007, pag.1415
    ackdPacketCount = ackdPacketCount + numel(sicCol);

    sourcesReady = find(sourceStatus);
    sourcesCollided = setdiff(sourcesReady,sicRow);
    % if numel(sourcesCollided) > 0 % TODO: add a conditional to disable/enable retransmission of collided packets [Issue: https://github.com/afcuttin/crdsa/issues/10]
    %     pcktCollisionCount = pcktCollisionCount + numel(sourcesCollided);
    %     sourceStatus(sourcesCollided) = 2;
    % end

    sourceStatus = sourceStatus - 1; % update sources statuses
    sourceStatus(sourceStatus < 0) = 0; % idle sources stay idle (see permitted statuses above)
end

loadNorm = pcktTransmissionAttempts / (simulationTime * randomAccessFrameLength)
throughputNorm = ackdPacketCount / (simulationTime * randomAccessFrameLength)
pcktCollisionProb = pcktCollisionCount / (simulationTime * randomAccessFrameLength);
packetLossRatio = 1 - ackdPacketCount / pcktTransmissionAttempts
