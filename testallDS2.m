%% ʾ������
% ʾ��Ŀ��ժҪ  ����DS2��ÿһ�������ļ�������׼ȷ��

%% �� 1 ����
% first �����˵��


%% �� 2 ����
% second �����˵��

%DS2=[100,103,105,111,113,117,121,123,200,202,210,212,213,214,219,221,222,228,231,232,233,234];
t1=clock;
DS2=[100];
sampleOriginPath='E:\matlab\0402\MIT-BIH Arrhythmia Database\';
allaccuracy=[];
for tk=1:size(DS2,2)
    testallDS2num=DS2(1,tk);
    eval(['[Presult',num2str(tk),',TypeResult',num2str(tk),',accuracy] = predictClass(sampleOriginPath,testallDS2num);']);
    %������һ���ų�����Ϊδ����allaccuracy���Ҿ��ò����ٲ�����,����дmFC��
    allaccuracy(end+1)=accuracy;
end
t2=clock;
t3=etime(t2,t1);
fprintf('testallDS2 cost: %.4f',t3);