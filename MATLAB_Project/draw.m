%给出音频数组和采样率，绘制音频时域和频域图
function draw(site,x,fs)
    N=length(x);
    n=N-1;
    t=(0:N-1)/fs;
    X=fft(x);
    f=fs/N*(0:round(N/2)-1);
    plot(site,f,abs(X(1:round(N/2))));
%    axis([0 3000 0 max(f)]);
    xlabel('Frequency/(s)');ylabel('Amplitude');
    title('信号的频谱');
    grid;
end