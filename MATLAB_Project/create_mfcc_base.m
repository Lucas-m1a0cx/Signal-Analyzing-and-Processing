% 创建mfcc库 'mfcc_base.mat'
function create_mfcc_base()
musicbank = dir(fullfile('E:\xinhaodazuoye\Project\musicbase','*.mp3'));
musicnames = {musicbank.name}';
musicnames = strrep(musicnames,'.mp3','');
for i=1:length(musicbank)
    filenames = strcat("E:\xinhaodazuoye\Project\musicbase\",musicnames{i},'.mp3'); % 注意反斜杠
    for j=1:3
        mfcc{i,j} = getmfcc_short(filenames,(j-1),j);
    end
end
save('mfcc_base.mat','mfcc','musicnames');
end