function y3=hp(x,fs)
    maxFreq = fs / 2;
    [hp_N, hp_Wn] = cheb2ord( 4000/ maxFreq, 2500 / maxFreq, 1, 40);
    [hp_b, hp_a] = cheby2(hp_N, 40, hp_Wn, 'high');
    % figure
    % freqz(hp_b, hp_a);
    % title("highpass")
    % [hp_sos, hp_g] = tf2sos(hp_b, hp_a);
    y3=filter(hp_b,hp_a,x);
end