function [ANNOT,FS1,FS2,FS3,FS4,FS5,FS6,FS7,FS8] = getFSfromSingle(originPath,num,outputPath)
% 此函数说明 期望得到FS1,...FS8






%务必检查num是不是被固定了，真坑
 subtrahend=300;%根据num=207时，不能小于270，方便起见，取300
%矩阵大小都按照qrson定吧
%输入的变量
originPath='E:\matlab\0402\MIT-BIH Arrhythmia Database\';

format='MIT';
recordsrc=[originPath,num2str(num)];
outputPath='E:\matlab\0402\newResult\';
frequency=360;
resultfilename=[num2str(num),'_ECG_delineation.mat'];

annotFILENAME=[num2str(num),'ANNOT','.mat'];
saveFSpath='E:\matlab\0402\FS\';
spk=1;
FSfilename=[num2str(num),'FS',num2str(spk),'.mat'];
%只检测FS1是否存在，如果存在了，默认8个FS都存在，直接加载
myRoot=[saveFSpath,num2str(num)];
if ~isdir(myRoot) %判断路径是否存在
    mkdir(myRoot);
    addpath(myRoot);
end 

if exist([saveFSpath,num2str(num),'\',FSfilename,' FS',num2str(spk)])
    eval(['load [',saveFSpath,num2str(num),'\',annotFILENAME,']']);
    for lpf=1:8
        FSfilename=[num2str(num),'FS',num2str(lpf),'.mat'];
        eval(['load  ',saveFSpath,num2str(num),'\',FSfilename,'']);%  不能使用括号，用了括号语句里就得加双引号
    end
else

if(exist([outputPath,resultfilename],'file'))
    clear wavedet;
    load([outputPath,resultfilename]);
else
    ECG_w=ECGwrapper();
    ECG_w.recording_name=recordsrc;
    ECG_w.recording_format=format;
    ECGt = ECGtask_ECG_delineation();
    ECGt.delineators = 'all-delineators';%没有用到ecgpuwave,改了方法不能用
    ECG_w.ECGtaskHandle= ECGt;
    ECG_w.output_path=outputPath;
    ECG_w.Run();
end

%------------------

%--------------------


% ECG_w=ECGwrapper();
% ECG_w.recording_name=recordsrc;
% ECG_w.recording_format=format;
% ECGt = ECGtask_ECG_delineation();
% ECGt.delineators = 'all-delineators';%没有用到ecgpuwave,改了方法不能用
% ECG_w.ECGtaskHandle= ECGt;
% ECG_w.output_path=outputPath;
% ECG_w.Run();
%在outputPath下得到num_ECG_delineation.mat,打开之后得到wavedet
%然后通过wavedet.MLII.Pon得到1x2271的矩阵，具体的MLII类型和矩阵长度可能需要读取hea文件得到

%---------------读取hea,期望得到信号的导联类型--------
heaName=[num2str(num),'.hea'];
head=fullfile(originPath,heaName);
heaid=fopen(head,'r');
z=fgetl(heaid);
A=sscanf(z,'%d%d%d%d',[1,4]);
H{1}=A;
for m=1:A(1,2)
    z=fgetl(heaid);
    p=m+1;
    H{p}={char(sscanf(z,'%8c%*d%*d%*d%*d%*d%*d%*d %*4c',[1,inf])),sscanf(z,'%*s %d %d %d %d %d %d %d %*4c',[1,7]),char(sscanf(z,'%*s%*d%*d%*d%*d%*d%*d%*d %4c',[1,inf]))};
         %100.dat 212 200 11 1024 995 -22131 0 MLII
end
z=fgetl(heaid);
H{p+1}={(sscanf(z,'%*s %d %*c %d %d %*s',[1,inf])),char(sscanf(z,'%*s %*d %c %*d%*d %*s',[1,inf])),char(sscanf(z,'%*s %*d %*c %*d%*d %s',[1,inf]))};%应该是空格的原因
z=fgetl(heaid);
H{p+2}=(sscanf(z,'%s %s ',[1,inf]));
fclose(heaid);
%MILL和V5的位置
leadAtype=H{1,2}(1,3);%'MLII'
leadBtype=H{1,3}(1,3);
leadAtype=H{1,2}(1,3);%'MLII'
leadBtype=H{1,3}(1,3);
qrsonFILENAME=[num2str(num),'qrson','.mat'];
qrsoffFILENAME=[num2str(num),'qrsoff','.mat'];
toffFILENAME=[num2str(num),'toff','.mat'];
if (exist([saveFSpath,num2str(num),'\',qrsonFILENAME],'file'))
    eval(['load ',saveFSpath,num2str(num),'\',qrsonFILENAME,'']);
    eval(['load  ',saveFSpath,num2str(num),'\',toffFILENAME,'']);
    eval(['load  ',saveFSpath,num2str(num),'\',qrsoffFILENAME,'']);
else
    eval(['qrson=wavedet.',leadAtype{1,1},'.QRSon;']);%矩阵的具体数值应该是第几个点
    eval(['rpeak=wavedet.',leadAtype{1,1},'.R;']);
    eval(['qrsoff=wavedet.',leadAtype{1,1},'.QRSoff;']);
    eval(['ton=wavedet.',leadAtype{1,1},'.Ton;']);
    eval(['tpeak=wavedet.',leadAtype{1,1},'.R;']);
    eval(['toff=wavedet.',leadAtype{1,1},'.Toff;']);
    %P波是否存在没法检测，就当全部都存在好了
    %检测qrsoff和toff是否含有NaN
    qrson=correctNaN(qrson);
        %rpeak=correctNaN(rpeak);
        %ton=correctNaN(ton);
        %tpeak=correctNaN(tpeak);
    qrsoff=correctNaN(qrsoff);
    toff=correctNaN(toff);  %这个后面要用
    
    eval(['save ',saveFSpath,num2str(num),'\',qrsonFILENAME,' qrson;']);
    eval(['save ',saveFSpath,num2str(num),'\',qrsoffFILENAME,' qrsoff;']);
    eval(['save ',saveFSpath,num2str(num),'\',toffFILENAME,' toff;']);
end

%--------------------------ECG滤波-------------------------------
datName=[num2str(num),'.dat'];
datd=fullfile(originPath,datName);
datid=fopen(datd);
A=fread(datid,[3 inf],'uint8');
fclose(datid);
M1H=bitand(A(2,:),15);
M2H=bitshift(A(2,:),-4);
%PRL=bitshift(bitand(A(:,2),8),9);%为什么要取出低四位中的最高位,答作为符号位
M(1,:)=bitshift(M1H,8)+A(1,:);%第一个信号
M(2,:)=bitshift(M2H,8)+A(3,:);%第二个信号
D(:,1)=M(1,:)';
D(:,2)=M(2,:)';
clear A;
D_QRSP=medfilt1(D,0.2*frequency); %200ms中值滤波
D_T=medfilt1(D_QRSP,0.6*frequency); %应该是中值滤波的原因
D_T(1,:)=D_T(3,:);% 拿两个正常的冒充一下，合理的做法应该是在D_QRS左边加上两个数，
D_T(2,:)=D_T(3,:);
%有点问题，D_passed和D的开头两个数值远高于R波峰值，760高于330，源于D_T

%end
%-------------------画图----------------
t=1:1:650000;
% figure(1)
% plot(t(1:3600),D(1:3600,1),t(1:3600),D_QRSP(1:3600,1),t(1:3600),D_T(1:3600));axis tight;legend('Original','200ms','600ms'); legend('boxoff');
% figure(2)
% subplot(311);plot(t(1:3600),D(1:3600,1));axis tight;ylabel('D');
% subplot(312);plot(t(1:3600),D_QRSP(1:3600,1));axis tight;ylabel('D_QRSP');
% subplot(313);plot(t(1:3600),D_T(1:3600));axis tight;ylabel('D_T');
%--------------------12-tap low-pass filter  没有被添加，假设已经经过了滤波-----------
D_passed=D-D_T; %---消除基线漂移后的振幅信号，包括导联A和导联B
%plot(t(1:3600),D(1:3600,1),t(1:3600),D_passed(1:3600,1));axis tight;legend('Original','Subtracted Baseline'); legend('boxoff');
%plot(t(646400:650000),D(646400:650000,1),t(646400:650000),D_passed(646400:650000,1));axis tight;legend('Original','Subtracted Baseline'); legend('boxoff');
%原始信号的末尾有一个夸张的下跌,看数据就是这样，数值768,消除基线漂移的末尾反而很正常，也可能只是100号文件的特例,因为末尾刚好是R波终点
%为了确保D_passed不含有NaN,测试一次，加上correctNaN函数




%------------------说明---------------------------------
% 'Pon' P wave onset
% 'P' P wave peak
% 'Poff' P wave offset
% 'QRSon' QRS complex onset
% 'qrs' QRS fiducial point, obtained from QRS detection.
% 'Q' Q wave peak
% 'R' R wave peak
% 'S' S wave peak
% 'QRSoff' QRS complex offset
% 'Ton' T wave onset
% 'T' T wave peak
% 'Toff' T wave offset
%-----------------处理wavedet.MLII.Pon--------------------------------------
loadname=[num2str(num),'_ECG_delineation.mat'];
load ([outputPath,loadname]);%得到wavedet

%--------------考虑下leadBtype------------------------------------------------------
% eval(['qrson=wavedet.',leadAtype{1,1},'.QRSon;']);%矩阵的具体数值应该是第几个点
% eval(['rpeak=wavedet.',leadAtype{1,1},'.R;']);
% eval(['qrsoff=wavedet.',leadAtype{1,1},'.QRSoff;']);
% eval(['ton=wavedet.',leadAtype{1,1},'.Ton;']);
% eval(['tpeak=wavedet.',leadAtype{1,1},'.R;']);
% eval(['toff=wavedet.',leadAtype{1,1},'.Toff;']);
% %P波是否存在没法检测，就当全部都存在好了
% %检测qrsoff和toff是否含有NaN
% qrson=correctNaN(qrson);
%     %rpeak=correctNaN(rpeak);
% qrsoff=correctNaN(qrsoff);
%     %ton=correctNaN(ton);
%     %tpeak=correctNaN(tpeak);
% toff=correctNaN(toff);  %这个后面要用

%--------------------------------------------------------------
atrName=[num2str(num),'.atr'];
atrd=fullfile(originPath,atrName);
atrid=fopen(atrd);
A=fread(atrid,[2 inf],'uint8');
fclose(atrid);
ATRTIME=[];
ANNOT=[];
sa=size(A,2);
saa=sa(1);
i=1;
while i<=saa
    annoth=bitshift(A(2,i),-2);%类型码在高位，第二个字节代表高位，也就是类型码在第二个字节的前6位
    if annoth==59
        ANNOT=[ANNOT;bitshift(A(2,i+3),-2)]; %临时的类型码
        ATRTIME=[ATRTIME;A(1,i+2)+bitshift(A(2,i+2),8)+...
        bitshift(A(1,i+1),16)+bitshift(A(2,i+1),24)]; %这是没有问题的，就是一个用四个8位表达一个长整型的数，2^32
        i=i+3; %跳过两个16位，一个不跳是i=i+1
    elseif annoth==60
        % nothing to do!
    elseif annoth==61
        % nothing to do!
    elseif annoth==62
        % nothing to do!
    elseif annoth==63 %就是10位描述了需要跳过的字节数，如果10位是奇数，还需要额外跳过一个空字节（8位）
        hilfe=bitshift(bitand(A(2,i),3),8)+A(1,i); %取低10位
        hilfe=hilfe+mod(hilfe,2);
        i=i+hilfe/2;%妙啊
    else
        ATRTIME=[ATRTIME;bitshift(bitand(A(2,i),3),8)+A(1,i)];
        ANNOT=[ANNOT;bitshift(A(2,i),-2)];
    end
	i=i+1;
end
 ANNOT(length(ANNOT))=ANNOT(end-1);
    ATRTIME_RR=ATRTIME;
ATRTIME= (cumsum(ATRTIME))/frequency;
%---------------------------直接处理完ATRTIME和ANNOT--------------
ATRTIME(1:subtrahend/2,:)=[];
ATRTIME(end-(subtrahend/2-1):end,:)=[];
ANNOT(1:subtrahend/2,:)=[];
ANNOT(end-(subtrahend/2-1):end,:)=[];
ATRTIME_RR(1:subtrahend/2,:)=[];
ATRTIME_RR(end-(subtrahend/2-1):end,:)=[];


%------------------------------------------------------------------
pre_RR=[];post_RR=[];average_RR=[];localAverage_RR=0;
localAverage_RR=sum(ATRTIME_RR(:,1),1)/size(ATRTIME_RR,1);
%for i=(1):(size(ATRTIME_RR,1)-subtrahend)
for i=(1):(size(ATRTIME_RR,1))
%for i=1:(size(qrson,2))
    if i<=1
        pre_RR(end+1)=ATRTIME_RR(i+1,1); %前两个心跳的前置心跳采用第三个和第四个的数据
    else 
        pre_RR(end+1)=ATRTIME_RR(i,1);
    end

    if  i>=(size(ATRTIME_RR,1)-1)
        post_RR(end+1)=ATRTIME_RR(i-1,1);
    else
        post_RR(end+1)=ATRTIME_RR(i+1,1);
    end

    if i<=5 %小于5，比如第4个，5+6+7+8+9 +4+3+2+1+1，
        sumAtrTime=0;
        for k=1:(5+i)
            sumAtrTime=sumAtrTime+ATRTIME_RR(k,1);
        end
        for k=1:(5-i)
            sumAtrTime=sumAtrTime+ATRTIME_RR(k,1);
        end
        average_RR(end+1)=sumAtrTime/10;
   
    elseif i>=(size(ATRTIME_RR,1)-5)
        sumAtrTime=0;
        for k=(i-5):size(ATRTIME,1)
            sumAtrTime=sumAtrTime+ATRTIME_RR(k,1);
        end
        for k=(2*size(ATRTIME,1)-5-i):size(ATRTIME,1)
            sumAtrTime=sumAtrTime+ATRTIME_RR(k,1);
        end
        average_RR(end+1)=sumAtrTime/10;   
        
    else
        sumAtrTime=0;
        for k=1:10
            sumAtrTime=sumAtrTime+ATRTIME_RR(k,1);
        end
        average_RR(end+1)=sumAtrTime/10;
    end
    
end
average_RR=average_RR';post_RR=post_RR';pre_RR=pre_RR';
%-----------------固定间隔心电图-----------------------------
%使用FP+50ms的组，也就是固定间隔的组别，3A,3B,4A,4B
%atrtimesize=(size(qrson,2));
%atrtimesize=(size(ATRTIME,1)-subtrahend);
atrtimesize=(size(ATRTIME,1));
QRS_3A=zeros([atrtimesize 10]);T_3A=zeros([atrtimesize 8]);
QRS_3B=zeros([atrtimesize 10]);T_3B=zeros([atrtimesize 8]);
QRS_4A=zeros([atrtimesize 10]);T_4A=zeros([atrtimesize 8]);
QRS_4B=zeros([atrtimesize 10]);T_4B=zeros([atrtimesize 8]);
%----------------------3A,3B--------------------------------
%for k=(1):(size(ATRTIME,1)-subtrahend)
for k=(1):(size(ATRTIME,1))
%for k=1:(size(qrson,2))
    QRSonTime=ATRTIME(k)-0.05;
    QRSoffTime=ATRTIME(k)+0.1;
    TonTime=ATRTIME(k)+0.15;
    ToffTime=ATRTIME(k)+0.5;
    QRSon=round(QRSonTime*360+1);
    QRSoff=round(QRSoffTime*360+1);
    Ton=round(TonTime*360+1);
    Toff=round(ToffTime*360+1);
    for s=1:10
%         QRS_3A是横向排列的，D_passed是纵向排列
        QRS_3A(k,s)=D_passed(QRSon+6*s-6,1);
        QRS_3B(k,s)=D_passed(QRSon+6*s-6,2);
    end
    for s=1:8
        T_3A(k,s)=D_passed(Ton+18*s-18,1);
        T_3B(k,s)=D_passed(Ton+18*s-18,2);
    end
end
%已经得到3A,3B组的morphology,
%---------------3A,3B end-----------------------------------
%使用mapminmax对dat进行归一化，值得注意的是这里是对分割完的每个样本进行归一化
%对于FP+50的部分，只对框内进行振幅的缩放处理
% 必须是先缩放后采样，对每个样本的每个窗口单独进行缩放
%----------------------4A,4B-----------------------------------
%for k=(1):(size(ATRTIME,1)-subtrahend)
for k=(1):(size(ATRTIME,1))
%for k=1:(size(qrson,2))
    QRSonTime=ATRTIME(k)-0.05;
    QRSoffTime=ATRTIME(k)+0.1;
    TonTime=ATRTIME(k)+0.15;
    ToffTime=ATRTIME(k)+0.5;
    QRSon=round(QRSonTime*360+1);
    QRSoff=round(QRSoffTime*360+1);
    Ton=round(TonTime*360+1);
    Toff=round(ToffTime*360+1);
    D_4AQRS=zeros([1 10]);
    D_4BQRS=zeros([1 10]);
    D_4AT=zeros([1 8]);
    D_4BT=zeros([1 8]);
    D_4AQRS_Origin=D_passed(QRSon:QRSoff,1);
    D_4BQRS_Origin=D_passed(QRSon:QRSoff,2);
    D_4AT_Origin=D_passed(Ton:Toff,1);
    D_4BT_Origin=D_passed(Ton:Toff,2);
    %-----------归一化----------------------------------------
    Map_4AQRS=mapminmax(D_4AQRS_Origin);
    Map_4BQRS=mapminmax(D_4BQRS_Origin);
    Map_4AT=mapminmax(D_4AT_Origin);
    Map_4BT=mapminmax(D_4BT_Origin);
    %-----------归一化 end------------------------------------
    for s=1:10
        D_4AQRS(1,s)=Map_4AQRS(1+6*s-6,1);
        D_4BQRS(1,s)=Map_4BQRS(1+6*s-6,1);
    end
    for s=1:8
        D_4AT(1,s)=Map_4AT(1+18*s-18,1);
        D_4BT(1,s)=Map_4BT(1+18*s-18,1);
    end
    QRS_4A(k,:) = D_4AQRS;
    T_4A(k,:)   = D_4AT;
    QRS_4B(k,:) = D_4BQRS;
    T_4B(k,:)   = D_4BT;   
end
%-----------------------4A,4B end-----------------------------------

%-----------------固定间隔心电图 end---------------------------
%可以组成FS3,FS4,FS7,FS8
local_RR=localAverage_RR*ones([size(pre_RR,1) 1]);
FS3=[pre_RR,post_RR,average_RR,local_RR,QRS_3A,T_3A];
FS4=[pre_RR,post_RR,average_RR,local_RR,QRS_4A,T_4A];
FS7=[pre_RR,post_RR,average_RR,local_RR,QRS_3B,T_3B];
FS8=[pre_RR,post_RR,average_RR,local_RR,QRS_4B,T_4B];
%---------------------FS3,FS4,FS7,FS8 end-----------------------------------

%-----------------------如法炮制获得FS1,FS2,FS5,FS6------------------
%只需更改QRSon等，Heartbeat Interval=[QRSoff-QRSon,Toff-QRSoff,boolean P]
%------------------------1A,1B------------------------
%使用FP+50ms的组，也就是固定间隔的组别，3A,3B,4A,4B
%atrtimesize=size(ATRTIME,1)-subtrahend;
atrtimesize=size(ATRTIME,1);
%atrtimesize=size(qrson,2);
QRS_1A=zeros([atrtimesize 10]);T_1A=zeros([atrtimesize 10]);
QRS_1B=zeros([atrtimesize 10]);T_1B=zeros([atrtimesize 10]);
QRS_2A=zeros([atrtimesize 10]);T_2A=zeros([atrtimesize 10]);
QRS_2B=zeros([atrtimesize 10]);T_2B=zeros([atrtimesize 10]);
%----------------------1A,1B--------------------------------
%for k=(1):(size(ATRTIME,1)-subtrahend)
for k=(1):(size(ATRTIME,1))
%for k=1:(size(qrson,2))
    QRSon=qrson(k);
    QRSoff=QRSon+30;%-----------------------------------------------------------------
    Ton=QRSoff;
    %与其在这人检查，不如直接修改qrsoff
    %Toff=toff(k);% 报了太多错，改又改不来，Toff=Ton+0.35*360;先运行通吧
    Toff=Ton+75;%看了一眼，大多介于70-85
    %------------------------------------------------------------------------------------------------有时间改过来
    
    num2QRS=QRSoff-QRSon;
    interval2QRS=(num2QRS-1)/9;
    num2T=Toff-Ton;
    interval2T=(num2T-1)/9;
    progression2QRS=1:interval2QRS:num2QRS;
    progression2T=1:interval2T:num2T;
    progressionDecade=1:10;
    D_2AQRS_temp=D_passed(QRSon:QRSoff,1);
    D_2BQRS_temp=D_passed(QRSon:QRSoff,2);
    D_2AT_temp=D_passed(Ton:Toff,1);
    D_2BT_temp=D_passed(Ton:Toff,2);
    D_2AQRS_Origin=interp1(D_2AQRS_temp,progression2QRS);
    D_2BQRS_Origin=interp1(D_2BQRS_temp,progression2QRS);
    D_2AT_Origin=interp1(D_2AT_temp,progression2T);
    D_2BT_Origin=interp1(D_2BT_temp,progression2T);
    
    
    
    %---------------------------------------
    
%         QRS_3A是横向排列的，D_passed是纵向排列
        QRS_1A(k,:)= D_2AQRS_Origin;
        QRS_1B(k,:)=D_2BQRS_Origin;
   
   
        T_1A(k,:)=D_2AT_Origin;
        T_1B(k,:)=D_2BT_Origin;
    
end
%计算Heartbeat Interval,得是纵向排列
heartbeat_1_1=qrsoff-qrson;
heartbeat_1_2=toff-qrsoff;  %需要对toff进行correctNaN
sizeqrson=size(qrson,2);
%sizeATRTIME=size(ATRTIME,1)-subtrahend;
sizeATRTIME=size(ATRTIME,1);
product=sizeqrson-sizeATRTIME;
% 问题在于heartbeat_1_2;
heartbeat_1=[heartbeat_1_1;heartbeat_1_2]';
heartbeat_test=heartbeat_1;%测试说明heartbeat_test出现NaN
for pk=1:product
    heartbeat_1(end,:)=[];
end

%pflag=ones(size(qrson,2),1);
%pflag=ones(size(ATRTIME,1)-subtrahend,1);
pflag=ones(size(ATRTIME,1),1);
heartbeat_1=[heartbeat_1,pflag];

%已经得到1A,1B组的morphology,
%---------------1A,1B end-----------------------------------
%对于1A和2A组，在采样的时候要用inerp1
%----------------------2A,2B-----------------------------------
%for k=(1):(size(ATRTIME,1)-subtrahend)
for k=(1):(size(ATRTIME,1))
%for k=1:(size(qrson,2))
    QRSon=qrson(k);
    QRSoff=QRSon+30;
    Ton=QRSoff;
    %Toff=toff(k);
    Toff=Ton+75;%-----------------------------------------------------------------有时间改过来
%     D_4AQRS=zeros([1 10]);
%     D_4BQRS=zeros([1 10]);
%     D_4AT=zeros([1 8]);
%     D_4BT=zeros([1 8]);
    %----------------------
    num4QRS=QRSoff-QRSon;
    intervalQRS=(num4QRS-1)/9;%----------------------------------------------
    num4T=Toff-Ton;
    intervalT=(num4T-1)/9;%-------------------------------------------------
    progression4QRS=1:intervalQRS:num4QRS;
    progression4T=1:intervalT:num4T;
    progressionDecade=1:10;
    D_4AQRS_temp=D_passed(QRSon:QRSoff,1);
    D_4BQRS_temp=D_passed(QRSon:QRSoff,2);
    D_4AT_temp=D_passed(Ton:Toff,1);
    D_4BT_temp=D_passed(Ton:Toff,2);
    D_4AQRS_Origin=interp1(D_4AQRS_temp,progression4QRS);
    D_4BQRS_Origin=interp1(D_4BQRS_temp,progression4QRS);
    D_4AT_Origin=interp1(D_4AT_temp,progression4T);
    D_4BT_Origin=interp1(D_4BT_temp,progression4T);
    %-------------------------
%     下面的丢弃
%     D_4AQRS_Origin=D_passed(QRSon:QRSoff,1);
%     D_4BQRS_Origin=D_passed(QRSon:QRSoff,2);
%     D_4AT_Origin=D_passed(Ton:Toff,1);
%     D_4BT_Origin=D_passed(Ton:Toff,2);
    %-----------归一化----------------------------------------
    Map_4AQRS=mapminmax(D_4AQRS_Origin);
    Map_4BQRS=mapminmax(D_4BQRS_Origin);
    Map_4AT=mapminmax(D_4AT_Origin);
    Map_4BT=mapminmax(D_4BT_Origin);
    %-----------归一化 end------------------------------------
    
        D_4AQRS=Map_4AQRS;
        D_4BQRS=Map_4BQRS;
    
    
        D_4AT=Map_4AT;
        D_4BT=Map_4BT;
    
    QRS_2A(k,:) = D_4AQRS;
    T_2A(k,:)   = D_4AT;
    QRS_2B(k,:) = D_4BQRS;
    T_2B(k,:)   = D_4BT;   
end
%-----------------------2A,2B end-----------------------------------



%想不通啊，为什么FS1,2,5,6会有NaN呢
%问题在于heartbeat_1
FS1=[pre_RR,post_RR,average_RR,local_RR,heartbeat_1,QRS_1A,T_1A];
FS5=[pre_RR,post_RR,average_RR,local_RR,heartbeat_1,QRS_1B,T_1B];
FS2=[pre_RR,post_RR,average_RR,local_RR,heartbeat_1,QRS_2A,T_2A];
FS6=[pre_RR,post_RR,average_RR,local_RR,heartbeat_1,QRS_2A,T_2A];

% FS3=[pre_RR,post_RR,average_RR,local_RR,QRS_3A,T_3A];
% FS4=[pre_RR,post_RR,average_RR,local_RR,QRS_4A,T_4A];
% FS7=[pre_RR,post_RR,average_RR,local_RR,QRS_3B,T_3B];
% FS8=[pre_RR,post_RR,average_RR,local_RR,QRS_4B,T_4B];
%------------------------------------------------------
%这应该是可以了吧，明早来看看
%成了！
%------------给ANNOT掐头去尾，输出---------------这下怎么掐头去尾？ecgkit与annot不一致
% ANNOT(1:subtrahend/2,:)=[];
% ANNOT(end-(subtrahend/2-1):end,:)=[];
%saveFSpath='E:\matlab\0402\FS\';
for spk=1:8
    FSfilename=[num2str(num),'FS',num2str(spk),'.mat'];
    eval(['save ',saveFSpath,num2str(num),'\',FSfilename,' FS',num2str(spk),';']);
end
annotFILENAME=[num2str(num),'ANNOT','.mat'];
eval(['save ',saveFSpath,num2str(num),'\',annotFILENAME,' ANNOT']);
end  %最前面的if的end



end

