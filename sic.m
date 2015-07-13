function [outRandomAccessFrame,ackedPcktsCol,ackedPcktsRow] = sic(inRandomAccessFrame,nonCollPcktsCol,nonCollPcktsRow)
% function [outRandomAccessFrame,ackedPcktsCol,ackedPcktsRow] = sic(inRandomAccessFrame,nonCollPcktsCol,nonCollPcktsRow)
%
% perform Successive Interference Cancellation (SIC) on a given Random Access Frame for Contention Resolution Diversity Slotted Aloha
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

% TODO: a maximum number of iterations should be available as an input parameter [Issue: https://github.com/afcuttin/crdsa/issues/6]
% According to Casini et al., 2007, pag.1415 the choice of N-max-iter = 10 appears to achieve most of the CRDSA recursive algorithm potential gain.

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
