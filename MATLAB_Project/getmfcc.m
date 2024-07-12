function audio_mfcc = getmfcc(audio,fs)
% 读取音频文件
% [audio, fs] = audioread(audioname);
% 变单声道
audio = mean(audio, 2);
% audio = audio((length(audio)/3 : length(audio)/2),:);

% 提取MFCC特征（3种方式）
numCoeffs = 13;             % 提取13个MFCC系数
windowLength = round(0.030 * fs);  % 30ms窗口长度
overlapLength = round(0.015 * fs); % 15ms重叠长度
win = hamming(windowLength, 'periodic');

% audio_mfcc = mfcc_m(audio,fs,24,numCoeffs,windowLength,overlapLength);
audio_mfcc = v_melcepst(audio,fs,'E0dD',numCoeffs,24,windowLength,overlapLength);
% audio_mfcc = mfcc(audio, fs, "Window", win,'LogEnergy', 'Ignore', ...
%     'NumCoeffs', numCoeffs,'OverlapLength', overlapLength);

end