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

acked_col=find(sum(randomAccessFrame>0)==1); % find slot indices of packets without collisions
if numel(acked_col) > 0
 %        % in this circumstance, there is no need to  perform SIC, because the number of the acknowledged packets is exaclty two times the number of active sources, thus saving computing time
 %        [row_c,col_c,twinSlotId] = find(randomAccessFrame);
 %      row=transpose(row_c);
 %      col=transpose(col_c);
 %      [~,col_ind]=ismember(acked_col,col);
 %      acked_row = row(col_ind); % find source indices of packets without collisions
 %        [sicRAF,sicCol,sicRow] = sic(randomAccessFrame,acked_col,acked_row); % do the Successive Interference Cancellation
 %    elseif numel(acked_col) == 0
 %        % sicRAF = randomAccessFrame;
 %        sicCol = [];
 %        sicRow = [];
 %    end



nonCollPacketIdx = 1;
while nonCollPacketIdx <= numel(nonCollPcktsCol)
    twinPcktCol = inRandomAccessFrame( nonCollPcktsRow(nonCollPacketIdx),nonCollPcktsCol(nonCollPacketIdx) ); % get twin packet slot id
    if sum(inRandomAccessFrame(:,twinPcktCol)>0) > 1 % twin packet has collided
        inRandomAccessFrame(nonCollPcktsRow(nonCollPacketIdx),twinPcktCol) = 0; % cancel interference
        if sum(inRandomAccessFrame(:,twinPcktCol)>0) == 1; % check if a new package can be acknowledged, thanks to interference cancellation
            nonCollPcktsCol(numel(nonCollPcktsCol) + 1) = twinPcktCol; % update non collided packets indices arrays
            nonCollPcktsRow(numel(nonCollPcktsRow) + 1) = find(inRandomAccessFrame(:,twinPcktCol));
        end
    elseif sum(inRandomAccessFrame(:,twinPcktCol)>0) == 1 % twin packet has not collided
        inRandomAccessFrame(nonCollPcktsRow(nonCollPacketIdx),twinPcktCol) = 0; % cancel interference
        nonCollTwinInd = find(nonCollPcktsCol == twinPcktCol);
        nonCollPcktsCol(nonCollTwinInd) = []; %remove the twin packet from the acked packets list
        nonCollPcktsRow(nonCollTwinInd) = [];
    end
    nonCollPacketIdx = nonCollPacketIdx + 1;
end
outRandomAccessFrame = inRandomAccessFrame;
ackedPcktsCol = nonCollPcktsCol;
ackedPcktsRow = nonCollPcktsRow;
