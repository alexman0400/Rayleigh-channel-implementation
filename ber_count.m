function [ new_uneq_ratios, new_eq_ratios ] = ber_count( unequalized_signal, equalized_signal, eq_ratios, uneq_ratios, ip )
    last_pos = length(unequalized_signal);
    temp_ip = [ip unequalized_signal(last_pos-2) unequalized_signal(last_pos-1) unequalized_signal(last_pos)];

    [number,ratio] = biterr(temp_ip, unequalized_signal);        % ratio = BER
    new_eq_ratios = [eq_ratios ratio];                 % appends the new BER value for SNR(k) in the end of the list of all BERs
    
    [number,ratio] = biterr(temp_ip, equalized_signal);        % ratio = BER
    new_uneq_ratios = [uneq_ratios ratio];                 % appends the new BER value for SNR(k) in the end of the list of all BERs
end

