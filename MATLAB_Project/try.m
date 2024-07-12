% 设置音频文件路径
audioFile = 'C:\Users\晨轩\Documents\MATLAB\Project\musicbase\稻香.mp3';

% 读取音频数据
[audioData, fs] = audioread(audioFile);

% 创建音频播放器对象
player = audioplayer(audioData, fs);

% 设置绘图
figure;
hPlot = plot(NaN, NaN); % 创建空的绘图对象
xlabel('Time (s)');
ylabel('Amplitude');
title('Real-time Audio Signal');

% 播放音频并实时绘图
bufferSize = 128; % 每次绘制的样本数
numSamples = length(audioData);
currentSample = 1;

play(player); % 开始播放音频
while isplaying(player) && currentSample + bufferSize <= numSamples
    % 获取当前需要绘制的音频数据
    plotData = audioData(currentSample:currentSample + bufferSize - 1);
    % 获取时间轴
    t = (currentSample:currentSample + bufferSize - 1) / fs;
    % 更新绘图数据
    set(hPlot, 'XData', t, 'YData', plotData);
    drawnow;
    % 更新当前样本索引
    currentSample = currentSample + bufferSize;
end

% 检查是否还有剩余的数据
if currentSample < numSamples
    plotData = audioData(currentSample:end);
    t = (currentSample:length(audioData)) / fs;
    set(hPlot, 'XData', t, 'YData', plotData);
    drawnow;
end

disp('Audio playback finished.');
