function [Presult,TypeResult,accuracy] = predictClass(sampleOriginPath,samplenum)
%DECIDECLASS ����һ��dat�ļ���2271x5�������ԣ�����2271�����
%   ��Ȼ�ǲ��ԣ�����û��.atr�ļ�����ʹ��
%   ��Presult��2271x5�����pN,pS,pV,pF,pQ,���TypeResult,accuracy�Ǹ�������׼ȷ��

%samplenum=100;
%sampleOriginPath='E:\matlab\0402\MIT-BIH Arrhythmia Database\';
originPath='E:\matlab\0402\MIT-BIH Arrhythmia Database\';%ǰ���ǲ��Լ���������ѵ����·��
DS1=[101,106,108,109,112,114,115,116,118,119,122,124,201,203,205,207,208,209,215,220,223,230];
%DS1=[101];
comTSoutputPath='E:\matlab\0402\allFSNSVFQ\';
pdCoutputPath='E:\matlab\0402\TypeResult\';
pdCfilename=[num2str(samplenum),'TypeResult.mat'];

[testANNOT,testFS1,testFS2,testFS3,testFS4,testFS5,testFS6,testFS7,testFS8]=getFSfromSingle(sampleOriginPath,samplenum);%�õ�ANNOT
%�õ�ĳһ��FS��ѵ���� testFS1������NaN
%�ظ��˴Σ�ÿһ�ζ��õ�2271x5
for k=1:8
    Pname=['FS',num2str(k),'allPossibility'];
    [trainFS1N,trainFS1S,trainFS1V,trainFS1F,trainFS1Q] = combineTrainSet(originPath,DS1,k,comTSoutputPath);%trainFS1N��ָ1...8�е�һ��
    temptest=0;
    eval([Pname,'=caculatePossibility(testFS',num2str(k),',trainFS1N,trainFS1S,trainFS1V,trainFS1F,trainFS1Q,samplenum);']) ;
    clear trainFS1N;clear trainFS1S;clear trainFS1V;clear trainFS1F;clear trainFS1Q;
end
%�õ�FS1..8allPossibility
Presult=[];%Presult 2271x5,����ÿһ�������������ۺϸ���
TypeResult=char([]);%������������
fivetype=['N';'S';'V';'F';'Q'];
c3=clock;

if exist([pdCoutputPath,pdCfilename],'file')
    eval(['load ',pdCoutputPath,pdCfilename,';']);
else

pdCc1=clock;


for k=1:size(FS1allPossibility,1)
    for j=1:8
        eval(['P',num2str(j),'=FS',num2str(j),'allPossibility(k,:);']);
    end
    Presult(end+1,:)=sumP(P1,P2,P3,P4,P5,P6,P7,P8); %sumP ���ص���5��1x1,����ʵ����Presultֻ��һ����
    max=0;tempP=0;
    for i=1:5
        if Presult(end,i)>tempP
            max=i;tempP=Presult(end,i);
        end
    end
    TypeResult(end+1,1)=fivetype(i,1);
end

eval(['save ',pdCoutputPath,pdCfilename,' TypeResult']);
pdCc2=clock;
pdCSumcost=etime(pdCc2,pdCc1);
fprintf('pdCSumcost: %.4f',pdCSumcost);
end


c4=clock;
Pcost=etime(c4,c3);
fprintf('Pcost: %.4f', Pcost);

%------------------------end--------------------------------------
%��Ȼ��ANNOT��˳�����׼ȷ�ʰɣ�ժ����һ���ֲ�Ӱ�����У�����Ҫ���Ҳ���.atr����Ӱ������
shouldbe=char([]);ANNOT=testANNOT;
for k=1:size(ANNOT,1)
    if ANNOT(k,1)==1||ANNOT(k,1)==2||ANNOT(k,1)==3||ANNOT(k,1)==34||ANNOT(k,1)==11
        shouldbe(end+1,1)='N';
    end
    if ANNOT(k,1)==8||ANNOT(k,1)==4||ANNOT(k,1)==7||ANNOT(k,1)==9
        shouldbe(end+1,1)='S';
    end
    if ANNOT(k,1)==5||ANNOT(k,1)==10
        shouldbe(end+1,1)='V';
    end
    if ANNOT(k,1)==6
        shouldbe(end+1,1)='F';
    end
    if ANNOT(k,1)==12||ANNOT(k,1)==38||ANNOT(k,1)==13
        shouldbe(end+1,1)='Q';
    end
end


trueResults=0;falseResults=0;
for k=1:size(shouldbe,1)
    if TypeResult(k,1)==shouldbe(k,1)
        trueResults=trueResults+1;
    else 
        falseResults=falseResults+1;
    end
end
accuracy=trueResults/(trueResults+falseResults);

end

