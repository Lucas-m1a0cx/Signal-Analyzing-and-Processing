%IIR低通滤波器
function y1=lp(x,fs)
    maxFreq = fs / 2;
    [lp_N, lp_Wn] = cheb2ord(180 / maxFreq, 360 / maxFreq, 1, 40);
    [lp_b, lp_a] = cheby2(lp_N, 40, lp_Wn, 'low');
    % figure
    % freqz(lp_b, lp_a);
    % title("lowpass");
    % [lp_sos, lp_g] = tf2sos(lp_b, lp_a);
    y1=filter(lp_b,lp_a,x);  
end