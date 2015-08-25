clear all;
randomDataLength = 1000000; %bits
binaryData = randi([0 1],1,randomDataLength);
EsN0dB = [-4:1:12];

EsN0 = 10.^(EsN0dB / 10);
% line encoding
	nrzEncodedData = binaryData;
	nrzEncodedData(nrzEncodedData == 0) = -1;

	%serial to parallel conversion, split nrzEncodedData in to two bit streams, separating even/odd position bits
	nrzEncodedDataI = nrzEncodedData(1:2:length(nrzEncodedData));
	nrzEncodedDataQ = nrzEncodedData(2:2:length(nrzEncodedData));

	% modulation in the Hilbert space
	modulatedSignal = 1/sqrt(2) * complex(nrzEncodedDataI,nrzEncodedDataQ);

for i = 1:length(EsN0dB)
	% AWGN channel
	whiteNoise = sqrt(1/(2 * EsN0(i))) * complex(randn(1,length(modulatedSignal)),randn(1,length(modulatedSignal)));
	receivedSignal = modulatedSignal + whiteNoise;

	% demodulation
	demodOutI = real(receivedSignal);
	demodOutQ = imag(receivedSignal);

	% hard-decision decoding
	hardDecI = demodOutI >= 0;
	% hardDecI(hardDecI >= 0) = 1;
	% hardDecI(hardDecI < 0) = -1;
	hardDecQ=demodOutQ >= 0;
	% hardDecQ(hardDecQ >= 0) = 1;
	% hardDecQ(hardDecQ < 0) = -1;

	% Bit Error Rate estimation
	decodedData= zeros(1,randomDataLength);
	decodedData(1:2:randomDataLength) = hardDecI;
	decodedData(2:2:randomDataLength) = hardDecQ;

	ber(i) = sum(decodedData ~= binaryData) / randomDataLength

	theoreticalBer(i) = .5 * (2 * qfunc(sqrt(EsN0(i))) * (1 - 0.5 * qfunc(sqrt(EsN0(i)))))
end

% figure;
% subplot(1,2,1)
% plot(receivedSignal,'+');
% hold on;
% plot(modulatedSignal,'ro','MarkerFaceColor','r');
% subplot(1,2,2)
semilogy(EsN0dB,ber,'*',EsN0dB,theoreticalBer,'o');
grid on;


