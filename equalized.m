function [ equalized_output ] = equalized( noised_output_of_rect_filter, h, pt, OVERSAMPLING )

%Equalizing the signal
equalized_signal=(conj(h).*noised_output_of_rect_filter)./sqrt(norm(h,2));

%Plotting the signal with equalization
% figure(2)
% subplot(2,1,2,'replace')
% stem(equalized_signal)
% title('Equalized signal')
% xlabel('Samples')
% ylabel('Amplitude')

%Receiver side; Using a matched filter (that is matched to the rect pulse in the transmitter)
 
yy = conv(equalized_signal,pt);

% figure(1)
% subplot(6,1,5,'replace')
% stem(yy)
% title('Matched filter for equalized signal output at Rx side')
% xlabel('Samples')
% ylabel('Amplitude')

%Downsampling by 4, since the actual value of the output is shifted to 4th sample
 
y_down = downsample(yy,OVERSAMPLING,OVERSAMPLING-1);
 
% figure(1)
% title('Equalized signal')
% subplot(6,1,6,'replace')
% stem(y_down);
% title('Downsampled equalized signal output');
% xlabel('Samples');
% ylabel('Amplitude');

%scatterplot values for one h

values=[noised_output_of_rect_filter(1) equalized_signal(1)];
% scatterplot(values)
% title(['Rotation where h=', num2str(h(1))]);
% xlabel('Re');
% ylabel('Im');

for j = 1:length(y_down)                    % trying to find the true value of y
    if y_down(j)>0
        equalized_output(j) = 1;                    
    else
        equalized_output(j) = 0;
    end
end

end