function [ unequalized_output ] = unequalized( noised_output_of_rect_filter, h, pt, OVERSAMPLING )


%Receiver side; Using a matched filter (that is matched to the rect pulse in the transmitter)
 
yy = conv(noised_output_of_rect_filter,pt);

% figure(1)
% 
% subplot(6,1,3,'replace')
% stem(yy)
% title('Matched filter for unequalized signal output at Rx side')
% xlabel('Samples')
% ylabel('Amplitude')

%Downsampling by 4, since the actual value of the output is shifted to 4th sample
 
y_down = downsample(yy,OVERSAMPLING,OVERSAMPLING-1);
 
% figure(1)
% subplot(6,1,4,'replace')
% stem(y_down);
% title('Downsampled unequalized signal output');
% xlabel('Samples');
% ylabel('Amplitude');

for j = 1:length(y_down)                    % trying to find the true value of y
        if y_down(j)>0
            unequalized_output(j) = 1;                    
        else
            unequalized_output(j) = 0;
        end
end

end