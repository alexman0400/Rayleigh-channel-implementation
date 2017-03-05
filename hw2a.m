clc;
clf;
clear all; close all;

%A
eq_ratios = [];
uneq_ratios = [];
disp('First part of lab exercise')
SNR = input('Give SNR values (in dB):\n');   % SNR VALUE
bit_length = input('Give the number of bits the signal must have:\n');
ip=rand(1,bit_length)>0.5;                  % generating 0,1 with equal probability
x=2*ip-1;
OVERSAMPLING = 10; 
upsampled_x = upsample(x,OVERSAMPLING);

%Normalizing the pulse shape to have unit energy
 
pt = [ones(1,OVERSAMPLING) 0 0 0 0 0 0]/sqrt(OVERSAMPLING);
 
%Impulse response of a rectangular pulse, convolving the oversampled input with rectangular pulse
%The output of the convolution operation will be in the transmitter side
 
output_of_rect_filter = conv(upsampled_x,pt);
 
% figure(1)
% subplot(4,1,1)
% stem(output_of_rect_filter);
% title('Output of Rectangular Filter at Tx side')
% xlabel('Samples')
% ylabel('Amplitude')

%The output of an h channel
h=0.5*rand(1,length(output_of_rect_filter));
output_of_rayleigh_channel = h.*output_of_rect_filter;

for k=1:length(SNR)
%     disp(['SNR = ', num2str(SNR(k))])
    %Adding noise to the signal due to AWGN channel

    noised_output_of_rect_filter = awgn(complex(output_of_rayleigh_channel),SNR(k));

%     figure(1)
%     subplot(4,1,2,'replace')
%     stem(noised_output_of_rect_filter);
%     title('Output of Rectangular signal with noise travveling through the channel')
%     xlabel('Samples')
    ylabel('Amplitude')

    %Plotting the signal without equalization
%     figure(2)
%     subplot(2,1,1,'replace')
%     stem(noised_output_of_rect_filter)
%     title('Unequalized signal')
%     xlabel('Samples')
%     ylabel('Amplitude')
% 
%     disp('Press enter to see values for an equalized signal')
%     pause;
    
    %Equalized the signal
    equalized_signal=equalized(noised_output_of_rect_filter, h, pt, OVERSAMPLING);
%     disp('Press enter to see values for an unequalized signal')
%     pause;
    
    %Unequalized the signal
    unequalized_signal=unequalized(noised_output_of_rect_filter, h, pt, OVERSAMPLING);
    
    %Getting the essential BER values for this SNR value
    [uneq_ratios, eq_ratios] = ber_count(unequalized_signal, equalized_signal, eq_ratios, uneq_ratios, ip);

end

figure(3)
title('BER GRAPH')
semilogy(SNR,uneq_ratios,'b*-','linewidth',2);
hold on
semilogy(SNR,eq_ratios,'rs--','linewidth',2);
grid on
xlabel('SNR values')
ylabel('BER values')