clc;
clf;
clear all; close all;

%C
disp('Third part of lab exercise')
SNR = input('Give SNR values (in dB):\n');   % SNR VALUE
antennas = input('Give number of antennas:\n');
bit_length = input('Give the number of bits the signal must have:\n');

T=10;
BER=[];

ip=rand(1,bit_length)>0.5;                  % generating 0,1 with equal probability
x=2*ip-1;
OVERSAMPLING = 1; 
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

for k=1:length(SNR)
     for kk=1:antennas

        %The output of an h channel
        h(:,kk)=0.5*rand(1,length(output_of_rect_filter));
        
        %Making the values of h be the same for every 10 elements
        h_count=0;
        flag=0;
        temp_h=h(1,kk);
        for w=1:length(output_of_rect_filter)
            if(flag==1)
                temp_h=h(w,kk);
                flag=0;
            end
            h(w,kk)=temp_h;
            if (rem(w,T)==0)
                flag=1;
            end
        end
        
        output_of_rayleigh_channel(kk,:) = (h(:,kk)').*output_of_rect_filter;

        %Adding noise to the signal due to AWGN channel

        noised_output_of_rect_filter(kk,:) = awgn(complex(output_of_rayleigh_channel(kk,:)),SNR(k));

%         figure(1)
%         subplot(4,1,2,'replace')
%         stem(noised_output_of_rect_filter(kk,:));
%         title('Output of Rectangular signal with noise travveling through the channel')
%         xlabel('Samples')
%         ylabel('Amplitude')

        %Plotting the signal without equalization
%         figure(2)
%         subplot(2,1,1,'replace')
%         stem(noised_output_of_rect_filter(kk,:))
%         title('Unequalized signal')
%         xlabel('Samples')
%         ylabel('Amplitude')

        %Equalizing the signal
        equalized_signal(kk,:)=(conj(h(:,kk).*noised_output_of_rect_filter(kk,:)')./sqrt(norm(h,2)));

        %Plotting the signal with equalization
%         figure(2)
%         subplot(2,1,2,'replace')
%         stem(equalized_signal(kk,:))
%         title('Equalized signal')
%         xlabel('Samples')
%         ylabel('Amplitude')
    end

    %MRC
    col = size(equalized_signal,2);
    a = conj(h)/sqrt(norm(h(kk),2));
    for c=1:col
        yMRC(c) = a(c,:)*equalized_signal(:,c);
    end
    %Receiver side; Using a matched filter (that is matched to the rect pulse in the transmitter)

    yy = conv(yMRC,pt);

%     figure(1)
%     subplot(4,1,3,'replace')
%     stem(yy)
%     title('Matched filter output at Rx side')
%     xlabel('Samples')
%     ylabel('Amplitude')

    %Downsampling by 4, since the actual value of the output is shifted to 4th sample

    y_down = downsample(yy,OVERSAMPLING,OVERSAMPLING-1);

%     figure(1)
%     subplot(4,1,4,'replace')
%     stem(y_down);
%     title('Downsampled output');
%     xlabel('Samples');
%     ylabel('Amplitude');

    %scatterplot values for one h
    
    values=[noised_output_of_rect_filter(1) equalized_signal(1)];
%     figure(3)
%     scatterplot(values)
%     title(['Rotation where h=', num2str(h(1))]);
%     xlabel('Re');
%     ylabel('Im');
% 
%     disp(['SNR = ', num2str(SNR(k))])
%     disp('Press enter to see the graph for the next SNR value you entered')
%     pause;

    for j = 1:bit_length                        % trying to find the true value of y
        if y_down(j)>0
            temp(j) = 1;                    
        else
            temp(j) = 0;
        end
    end
    
    [number,ratio] = biterr(ip,temp);
    BER = [BER ratio];                 % appends the new BER value for SNR(k) in the end of the list of all BERs
%     disp(['ratio for this is ', num2str(ratio)]);
end

%C

%Plot BER for k number of antenas
% disp('Press enter to see BER graph for ', num2str(k),'the next SNR value you entered')

title('BER GRAPH');
semilogy(SNR,BER,'k*-','linewidth',2);
hold on
grid on
xlabel('SNR values')
ylabel('BER values')
 
    
