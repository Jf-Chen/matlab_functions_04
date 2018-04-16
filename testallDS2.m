%% 示例标题
% 示例目标摘要  测试DS2的每一个数据文件，计算准确率

%% 节 1 标题
% first 代码块说明


%% 节 2 标题
% second 代码块说明

%DS2=[100,103,105,111,113,117,121,123,200,202,210,212,213,214,219,221,222,228,231,232,233,234];
t1=clock;
DS2=[100];
sampleOriginPath='E:\matlab\0402\MIT-BIH Arrhythmia Database\';
allaccuracy=[];
for tk=1:size(DS2,2)
    testallDS2num=DS2(1,tk);
    eval(['[Presult',num2str(tk),',TypeResult',num2str(tk),',accuracy] = predictClass(sampleOriginPath,testallDS2num);']);
    %到了下一步才出错，因为未命名allaccuracy，我觉得不用再测试了,可以写mFC了
    allaccuracy(end+1)=accuracy;
end
t2=clock;
t3=etime(t2,t1);
fprintf('testallDS2 cost: %.4f',t3);