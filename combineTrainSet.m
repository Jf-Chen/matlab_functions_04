function [N,S,V,F,Q] = combineTrainSet(originPath,DS1,typenum,comTSoutputPath)
%COMBINETRAINSET �����������FS1,FS8֮һ�õ�FSN,...FSF�ķ���
%   ��������������DS1��Ϊѵ���������FS1��FS1N,FS1S,FS1V,FS1F,FS1Q,...FS8��FS8N,FS8S,FS8V,FS8F,FS8Q
%   DS1=[100,...]��Ϊ��������
%   Ϊ�˱�������ظ����Ͳ��ֿ�д��8������������ֻȡFS1��һ�����������ˣ�
%   �����ò��Ű���ֻҪ���⺯����Ϊһ�����־ͺ��ˣ�����FS1,ANNOT�����N,S,V,F,Q���У���������ͺã�
%   ��дһ�����ANNOT��FS1�ĺ�����ȫ����FS1��ANNOT,���ף�
%   ��һ����ֻ�������뵥��100.dat��FS1(8ȡ1),��ANNOT,���N,S,V,F,Q,��Ϊ��С�ĺ���������ĵط�ȥ�ϲ�
%   ������ϲ�����getNSVFQ����
%   �ϲ���ʲô�أ�

% DS1=[101,106,108,109,112,114,115,116,118,119,122,124,201,203,205,207,208,209,215,220,223,230];
% originPath='E:\matlab\0402\MIT-BIH Arrhythmia Database\';
% comTSoutputPath='E:\matlab\0402\newResult\';

%DS1Ҳ��Ϊ����֮һ��������ʽΪÿһ��Ԫ�ض��� getFSfromSingle��������������а�����Ҫ����ֱ�ѡ��.dat&.atr���ļ�·����
%�����Ǹ�Ŀ¼�ͺã�������µĺ�����д�ɣ����ֻдDS1��
%   �����DS1ȫ����N,S,V,F,Q,��FS9��
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
%���ֻ�������һ��,��typenum�ö�
ti=0;
for k=1:size(DS1,2)
    ti=ti+1;
    num=DS1(1,k);
    [ANNOT,FS1,FS2,FS3,FS4,FS5,FS6,FS7,FS8]=getFSfromSingle(originPath,num,comTSoutputPath);
    %getNSVFQ(FS1,ANNOT); %���һ��FS1...8
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
eval(['V=allFS',num2str(typenum),'V;']);%Ϊʲ�����[]�أ�
eval(['F=allFS',num2str(typenum),'F;']);
eval(['Q=allFS',num2str(typenum),'Q;']);

eval(['save ',comTSoutputPath,wantedfilename,' N S V F Q']);

end
% cbTS_N=N;cbTS_S=S;cbTS_V=V;cbTS_F=F;cbTS_Q=Q;
% ti=ti+1
% save('combineTrainset5','cbTS_N','cbTS_S','cbTS_V','cbTS_F','cbTS_Q');


%--------------���allFS9M------
end

