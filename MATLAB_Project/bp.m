function y2=bp(x,fs)
    maxFreq = fs / 2;
    [bp_N, bp_Wn] = cheb2ord([400, 3000] / maxFreq, [150, 5000]  / maxFreq, 1, 40);
    [bp_b, bp_a] = cheby2(bp_N, 40, bp_Wn, 'bandpass');
    % figure
    % freqz(bp_b, bp_a);
    % title("bandpass")
    % [bp_sos, bp_g] = tf2sos(bp_b, bp_a);
    y2=filter(bp_b,bp_a,x);
end