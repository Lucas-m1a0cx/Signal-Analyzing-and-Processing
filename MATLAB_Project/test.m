% clc;
% clear;

% create_mfcc_base(); % 创建mfcc特征库
% load('mfcc_base.mat'); % 导入特征库
% mfcc_test = getmfcc("testmusic\一路向北_1.mp3"); % 这里放测试用曲子

% 将例子与库中曲子进行mfcc比对
% for i=1:length(mfcc)
%     for j=1:3
%         [dist{i,j} ix iy] = dtw(mfcc_test',mfcc{i,j}'); % 用dtw进行特征比对
%         % 显示计算结果
%         % figure;
%         % plot(ix, iy);
%         % xlabel('test');
%         % ylabel(musicnames(i,1));
%         % title(['DTW匹配距离: ', num2str(dist{i,j})]);
%     end
% end

% 查找结果
% best = dist{1,1};
% for i=1:length(mfcc)
%     for j = 1:3
%         if (dist{i,j} <= best)
%             best = dist{i,j};
%             index = i;
%         end
%     end
% end
% % 显示查找结果
% fprintf('The best matched music is %s\n',musicnames{index});

%% 函数部分

% 创建mfcc库 'mfcc_base.mat'
function create_mfcc_base()
musicbank = dir(fullfile('musicbase','*.mp3'));
musicnames = {musicbank.name}';
musicnames = strrep(musicnames,'.mp3','');
for i=1:length(musicbank)
    filenames = strcat("musicbase\",musicnames{i},'.mp3'); % 注意反斜杠
    for j=1:3
        mfcc{i,j} = getmfcc_short(filenames,(j-1),j);
    end
end
save('mfcc_base.mat','mfcc','musicnames');
end



function audio_mfcc = getmfcc(audioname)
% 读取音频文件
[audio, fs] = audioread(audioname);
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

function audio_mfcc = getmfcc_short(audioname,startindex,endindex)
% 读取音频文件
[audio, fs] = audioread(audioname);
% 变单声道
audio = mean(audio, 2);
audio = audio((startindex*(length(audio)/3)+1 : endindex*(length(audio)/3)),:); % 截取一段

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


% 自定义的mfcc函数，效率不高但能用
function ccc = mfcc_m(x,fs,p,L,framesize,inc)
% 对输入的语音序列x进行MFCC参数的提取，
% 返回MFCC参数和一阶、二阶（可选）差分MFCC参数，Mel滤波器的个数为p，
% MFCC参数个数L，一般取12-16；采样频率为fs
% 按帧长为n点分为一帧，相邻两帧之间的帧移为inc
bank = v_melbankm(p,framesize,fs,0,0.5,'t'); 
% 归一化Mel滤波器组系数  
bank = full(bank); % 将稀疏矩阵转换为满存储 
bank = bank / max(bank(:)); 
% 计算DCT系数 L*p
for k = 1:L 
    n = 0:p-1; 
    dctcoef(k,:) = cos((2*n+1)*k*pi/(2*p));
end  
% 归一化倒谱
w = 1 + 0.5 * L * sin(pi*[1:L]./L);
w = w / max(w);
% 预加重滤波器  
xx = double(x);  
xx = filter([1,-0.97],1,xx);
% 语音信号分帧
xx = v_enframe(xx,framesize,inc); 
n2=fix(framesize/2)+1;
% 计算每帧的MFCC参数  
for i = 1:size(xx,1)  
    y = xx(i,:);  
    s = y' .* hamming(framesize);  
    t = abs(fft(s));
    t = t .^ 2;  
    c1 = dctcoef * log(bank*t(1:n2));
    c2 = c1 .* w';
    m(i,:) = c2;  
end  
% 求一阶差分系数  
dtm = zeros(size(m));  
for i = 3:size(m,1)-2  
    dtm(i,:) = -2 * m(i-2,:) - m(i-1,:) + m(i+1,:) + 2 * m(i+2,:);  
end  
dtm = dtm / 3;  
% 求取二阶差分系数  
dtmm = zeros(size(dtm));  
for i = 3:size(dtm,1)-2  
    dtmm(i,:) = -2 * dtm(i-2,:) - dtm(i-1,:) + dtm(i+1,:) + 2 * dtm(i+2,:);  
end  
dtmm = dtmm / 3;  
% 合并mfcc参数和一阶、二阶差分mfcc参数  
ccc = [m dtm dtmm];  
% 去除首尾几帧避免出现差分为0
ccc = ccc(101:size(m,1)-100,:);
end