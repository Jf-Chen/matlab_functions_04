function [Presult,TypeResult,accuracy] = predictClass(sampleOriginPath,samplenum)
%DECIDECLASS 给入一个dat文件，2271x5个可能性，给出2271个结果
%   既然是测试，可能没有.atr文件可以使用
%   用Presult（2271x5）替代pN,pS,pV,pF,pQ,输出TypeResult,accuracy是该样本的准确率

%samplenum=100;
%sampleOriginPath='E:\matlab\0402\MIT-BIH Arrhythmia Database\';
originPath='E:\matlab\0402\MIT-BIH Arrhythmia Database\';%前者是测试集，后者是训练集路径
DS1=[101,106,108,109,112,114,115,116,118,119,122,124,201,203,205,207,208,209,215,220,223,230];
%DS1=[101];
comTSoutputPath='E:\matlab\0402\allFSNSVFQ\';
pdCoutputPath='E:\matlab\0402\TypeResult\';
pdCfilename=[num2str(samplenum),'TypeResult.mat'];

[testANNOT,testFS1,testFS2,testFS3,testFS4,testFS5,testFS6,testFS7,testFS8]=getFSfromSingle(sampleOriginPath,samplenum);%得到ANNOT
%得到某一个FS的训练集 testFS1不包含NaN
%重复八次，每一次都得到2271x5
for k=1:8
    Pname=['FS',num2str(k),'allPossibility'];
    [trainFS1N,trainFS1S,trainFS1V,trainFS1F,trainFS1Q] = combineTrainSet(originPath,DS1,k,comTSoutputPath);%trainFS1N代指1...8中的一种
    temptest=0;
    eval([Pname,'=caculatePossibility(testFS',num2str(k),',trainFS1N,trainFS1S,trainFS1V,trainFS1F,trainFS1Q,samplenum);']) ;
    clear trainFS1N;clear trainFS1S;clear trainFS1V;clear trainFS1F;clear trainFS1Q;
end
%得到FS1..8allPossibility
Presult=[];%Presult 2271x5,代表每一个心跳的五种综合概率
TypeResult=char([]);%代表最终类型
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
    Presult(end+1,:)=sumP(P1,P2,P3,P4,P5,P6,P7,P8); %sumP 返回的是5个1x1,但是实际上Presult只是一个数
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
%既然有ANNOT就顺便输出准确率吧，摘除这一部分不影响运行，但是要是找不到.atr可能影响运行
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

