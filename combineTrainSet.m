function [N,S,V,F,Q] = combineTrainSet(originPath,DS1,typenum,comTSoutputPath)
%COMBINETRAINSET 期望由输入的FS1,FS8之一得到FSN,...FSF的分类
%   （划掉）以整个DS1作为训练集，输出FS1的FS1N,FS1S,FS1V,FS1F,FS1Q,...FS8的FS8N,FS8S,FS8V,FS8F,FS8Q
%   DS1=[100,...]作为矩阵输入
%   为了避免代码重复，就不分开写成8个函数以满足只取FS1这一特征的需求了，
%   好像用不着啊，只要把这函数作为一个区分就好了，输入FS1,ANNOT，输出N,S,V,F,Q就行，控制输入就好，
%   再写一个输出ANNOT和FS1的函数，全集的FS1和ANNOT,不妥，
%   这一函数只用来输入单个100.dat的FS1(8取1),和ANNOT,输出N,S,V,F,Q,作为最小的函数，到别的地方去合并
%   在这儿合并，在getNSVFQ生成
%   合并成什么呢？

% DS1=[101,106,108,109,112,114,115,116,118,119,122,124,201,203,205,207,208,209,215,220,223,230];
% originPath='E:\matlab\0402\MIT-BIH Arrhythmia Database\';
% comTSoutputPath='E:\matlab\0402\newResult\';

%DS1也作为输入之一，具体形式为每一个元素都是 getFSfromSingle的输入参数，不行啊，需要具体分别选择.dat&.atr的文件路径，
%而不是父目录就好，这个在新的函数里写吧，这儿只写DS1的
%   输出是DS1全集的N,S,V,F,Q,是FS9的
wantedfilename=['allFS',num2str(typenum)];
if exist([comTSoutputPath,wantedfilename],'file')
    eval(['load ',comTSoutputPath,wantedfilename,';'])
else
    



allFS1N=[];allFS1S=[];allFS1V=[];allFS1F=[];allFS1Q=[];
allFS2N=[];allFS2S=[];allFS2V=[];allFS2F=[];allFS2Q=[];
allFS3N=[];allFS3S=[];allFS3V=[];allFS3F=[];allFS3Q=[];
allFS4N=[];allFS4S=[];allFS4V=[];allFS4F=[];allFS4Q=[];
allFS5N=[];allFS5S=[];allFS5V=[];allFS5F=[];allFS5Q=[];
allFS6N=[];allFS6S=[];allFS6V=[];allFS6F=[];allFS6Q=[];
allFS7N=[];allFS7S=[];allFS7V=[];allFS7F=[];allFS7Q=[];
allFS8N=[];allFS8S=[];allFS8V=[];allFS8F=[];allFS8Q=[];
%最好只输出其中一种,用typenum裁定
ti=0;
for k=1:size(DS1,2)
    ti=ti+1;
    num=DS1(1,k);
    [ANNOT,FS1,FS2,FS3,FS4,FS5,FS6,FS7,FS8]=getFSfromSingle(originPath,num,comTSoutputPath);
    %getNSVFQ(FS1,ANNOT); %检测一下FS1...8
    suibianxiede=[];
    eval(['[N,S,V,F,Q]=getNSVFQ(FS',num2str(typenum),',ANNOT);']);
    %for j=1:8
    j=typenum;
        eval(['allFS',num2str(j),'N=[allFS',num2str(j),'N;N];']);
        eval(['allFS',num2str(j),'S=[allFS',num2str(j),'S;S];']);
        eval(['allFS',num2str(j),'V=[allFS',num2str(j),'V;V];']);
        eval(['allFS',num2str(j),'F=[allFS',num2str(j),'F;F];']);
        eval(['allFS',num2str(j),'Q=[allFS',num2str(j),'Q;Q];']);
    %end
%     allFS1N=[allFS1N;N];
%     allFS1S=[allFS1S;S];
%     allFS1V=[allFS1V;S];
%     allFS1F=[allFS1F;F];
%     allFS1Q=[allFS1Q;Q];
end

eval(['N=allFS',num2str(typenum),'N;']);
eval(['S=allFS',num2str(typenum),'S;']);
eval(['V=allFS',num2str(typenum),'V;']);%为什会等于[]呢？
eval(['F=allFS',num2str(typenum),'F;']);
eval(['Q=allFS',num2str(typenum),'Q;']);

eval(['save ',comTSoutputPath,wantedfilename,' N S V F Q']);

end
% cbTS_N=N;cbTS_S=S;cbTS_V=V;cbTS_F=F;cbTS_Q=Q;
% ti=ti+1
% save('combineTrainset5','cbTS_N','cbTS_S','cbTS_V','cbTS_F','cbTS_Q');


%--------------输出allFS9M------
end

