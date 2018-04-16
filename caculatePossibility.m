function [FS9P] = caculatePossibility(testFS9,FS3_N,FS3_S,FS3_V,FS3_F,FS3_Q,samplenum)
%CACULATEPOSIBILITY 计算某一个FS下的可能性
%trainFS9N,trainFS9S,trainFS9V,trainFS9F,trainFS9Q用FS3_N,FS3_S,FS3_V,FS3_F,FS3_Q替代
%allPosiblity用FS9P替代,含义是2271x5的概率值
%   此处显示详细说明

%计算训练集的均值
sizeN=size(FS3_N,1);
sizeS=size(FS3_S,1);
sizeV=size(FS3_V,1);
sizeF=size(FS3_F,1);
sizeQ=size(FS3_Q,1);
uN_FS3=sum(FS3_N,1)/sizeN;
uS_FS3=sum(FS3_S,1)/sizeS;
uV_FS3=sum(FS3_V,1)/sizeV;
uF_FS3=sum(FS3_F,1)/sizeF;%可是，用全部的训练集，怎么会等于[]呢
uQ_FS3=sum(FS3_Q,1)/sizeQ;
testID=samplenum;

sumcov_FS3_N=0;variable1=0;
for k=1:size(FS3_N)
    variable1=(FS3_N(k,1)- uN_FS3)*(FS3_N(k,1)-uN_FS3)';
    sumcov_FS3_N=sumcov_FS3_N+variable1;
end
sumcov_FS3_S=0;variable1=0;
for k=1:size(FS3_S)
    variable1=(FS3_S(k,1)-uS_FS3)*(FS3_S(k,1)-uS_FS3)';
    sumcov_FS3_S=sumcov_FS3_S+variable1;
end
sumcov_FS3_V=0;variable1=0;
for k=1:size(FS3_V)
    variable1=(FS3_V(k,1)-uV_FS3)*(FS3_V(k,1)-uV_FS3)';
    sumcov_FS3_V=sumcov_FS3_V+variable1;
end
sumcov_FS3_F=0;variable1=0;
for k=1:size(FS3_F)
    variable1=(FS3_F(k,1)-uF_FS3)*(FS3_F(k,1)-uF_FS3)';
    sumcov_FS3_F=sumcov_FS3_F+variable1;
end
sumcov_FS3_Q=0;variable1=0;
for k=1:size(FS3_Q)
    variable1=(FS3_Q(k,1)-uQ_FS3)*(FS3_Q(k,1)-uQ_FS3)';
    sumcov_FS3_Q=sumcov_FS3_Q+variable1;
end
wN=1;wS=1;wV=1;wF=1;wQ=1;
if sizeN>=400
    wN=400/sizeN;
end
if sizeS>=400
    wS=400/sizeS;
end
if sizeV>=400
    wV=400/sizeV;
end
if sizeF>=400
    wF=400/sizeF;
end
if sizeQ>=400
    wQ=400/sizeQ;
end
variable2=wN*sumcov_FS3_N+wS*sumcov_FS3_S+wV*sumcov_FS3_V+wF*sumcov_FS3_F+wQ*sumcov_FS3_Q;
variable3=wN*sizeN+wS*sizeS+wV*sizeV+wF*sizeF+wQ*sizeQ;
Sigma=variable2/variable3;
%------------------------计算x------------------------------------------
x=0;%x是与特征同等维数的测试变量
X=testFS9;
FS9P=[];
for kx=1:size(X,1)
    x=X(kx,:);
    YN=yk(uN_FS3,Sigma,1,x);%这是什么，是函数，代表一个计算式，算出来的就yk
    YS=yk(uS_FS3,Sigma,2,x);
    YV=yk(uV_FS3,Sigma,3,x);
    YF=yk(uF_FS3,Sigma,4,x);
    YQ=yk(uQ_FS3,Sigma,5,x);
    expYN=exp(YN);expYS=exp(YS);expYV=exp(YV);expYF=exp(YF);expYQ=exp(YQ);
    sumexpYL=expYN+expYS+expYV+expYF+expYQ;
    PNx=expYN/sumexpYL;
    PSx=expYS/sumexpYL;
    PVx=expYV/sumexpYL;
    PFx=expYF/sumexpYL;
    PQx=expYQ/sumexpYL;
    P=[PNx,PSx,PVx,PQx,PFx];%--------------------------------需要的是这个
    FS9P(end+1,:)=P;
end


%--------------------输出的FS9P是FS9特征下testFS9的2271x5个可能性---------
end

