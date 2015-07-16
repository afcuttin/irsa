function [outRandomAccessFrame,ackedPcktsCol,ackedPcktsRow] = sic(randomAccessFrame,twinsOverhead)
% function [outRandomAccessFrame,ackedPcktsCol,ackedPcktsRow] = sic(inRandomAccessFrame,nonCollPcktsCol,nonCollPcktsRow)
%
% perform Successive Interference Cancellation (SIC) on a given Random Access Frame for Contention Resolution Diversity Slotted Aloha
% TODO: update function help [Issue: https://github.com/afcuttin/irsa/issues/7]
%
% +++ Input parameters
% 		- inRandomAccessFrame: the matrix containing slots and packets informations
% 		- nonCollPcktsCol: an array containing the column indices of packets that did not encounter collision (can include acked twins)
% 		- nonCollPcktsRow: an array containing the row indices of packets that did not encounter collision (can include acked twins)
%
% +++ Output parameters
% 		- outRandomAccessFrame: the matrix containing slots and packets informations, after SIC
% 		- ackedPcktsCol: an array containing the column indices of acknowledged packets after SIC
% 		- ackedPcktsRow: an array containing the row indices of acknowledged packets after SIC

nonCollPcktsCol=find(sum(randomAccessFrame>0)==1); % find slot indices of packets without collisions
if numel(nonCollPcktsCol) == 0
        outRandomAccessFrame = randomAccessFrame;
        ackedPcktsCol = [];
        ackedPcktsRow = [];
    elseif numel(nonCollPcktsCol) > 0
        [row_c,col_c] = find(randomAccessFrame);
        row=transpose(row_c);
        col=transpose(col_c);
        [~,col_ind]=ismember(nonCollPcktsCol,col);
        nonCollPcktsRow = row(col_ind); % find source indices of packets without collisions

        nonCollPacketIdx = 1;
        while nonCollPacketIdx <= numel(nonCollPcktsCol) % TODO: a maximum number of IC iterations should be available as an input parameter [Issue: https://github.com/afcuttin/irsa/issues/11]
            twinPcktCol = twinsOverhead{ nonCollPcktsRow(nonCollPacketIdx),nonCollPcktsCol(nonCollPacketIdx) };
            for twinPcktIdx = 1:length(twinPcktCol)
                if sum(randomAccessFrame(:,twinPcktCol(twinPcktIdx))) > 1 % twin packet has collided
                    randomAccessFrame(nonCollPcktsRow(nonCollPacketIdx),twinPcktCol(twinPcktIdx)) = 0; % cancel interference
                    if sum(randomAccessFrame(:,twinPcktCol(twinPcktIdx))) == 1; % check if a new package can be acknowledged, thanks to interference cancellation
                        nonCollPcktsCol = [nonCollPcktsCol,twinPcktCol(twinPcktIdx)]; % update non collided packets indices arrays % TODO: The variable 'nonCollPcktsCol' appears to change size on every loop iteration. Consider preallocating for speed. [Issue: https://github.com/afcuttin/irsa/issues/12]
                        nonCollPcktsRow = [nonCollPcktsRow,find(randomAccessFrame(:,twinPcktCol(twinPcktIdx)))]; % TODO: The variable 'nonCollPcktsRow' appears to change size on every loop iteration. Consider preallocating for speed. [Issue: https://github.com/afcuttin/irsa/issues/10]
                    end
                elseif sum(randomAccessFrame(:,twinPcktCol(twinPcktIdx))>0) == 1 % twin packet has not collided
                    randomAccessFrame(nonCollPcktsRow(nonCollPacketIdx),twinPcktCol(twinPcktIdx)) = 0; % cancel interference
                    nonCollTwinInd = find(nonCollPcktsCol == twinPcktCol(twinPcktIdx));
                    nonCollPcktsCol(nonCollTwinInd) = []; %remove the twin packet from the acked packets list
                    nonCollPcktsRow(nonCollTwinInd) = [];
                end
            end
            nonCollPacketIdx = nonCollPacketIdx + 1;
        end
        outRandomAccessFrame = randomAccessFrame;
        ackedPcktsCol = nonCollPcktsCol;
        ackedPcktsRow = nonCollPcktsRow;
end
