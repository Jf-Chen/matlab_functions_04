function [ANNOT,FS1,FS2,FS3,FS4,FS5,FS6,FS7,FS8] = getFSfromSingle(originPath,num,outputPath)
% �˺���˵�� �����õ�FS1,...FS8






%��ؼ��num�ǲ��Ǳ��̶��ˣ����
 subtrahend=300;%����num=207ʱ������С��270�����������ȡ300
%�����С������qrson����
%����ı���
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
%ֻ���FS1�Ƿ���ڣ���������ˣ�Ĭ��8��FS�����ڣ�ֱ�Ӽ���
myRoot=[saveFSpath,num2str(num)];
if ~isdir(myRoot) %�ж�·���Ƿ����
    mkdir(myRoot);
    addpath(myRoot);
end 

if exist([saveFSpath,num2str(num),'\',FSfilename,' FS',num2str(spk)])
    eval(['load [',saveFSpath,num2str(num),'\',annotFILENAME,']']);
    for lpf=1:8
        FSfilename=[num2str(num),'FS',num2str(lpf),'.mat'];
        eval(['load  ',saveFSpath,num2str(num),'\',FSfilename,'']);%  ����ʹ�����ţ��������������͵ü�˫����
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
    ECGt.delineators = 'all-delineators';%û���õ�ecgpuwave,���˷���������
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
% ECGt.delineators = 'all-delineators';%û���õ�ecgpuwave,���˷���������
% ECG_w.ECGtaskHandle= ECGt;
% ECG_w.output_path=outputPath;
% ECG_w.Run();
%��outputPath�µõ�num_ECG_delineation.mat,��֮��õ�wavedet
%Ȼ��ͨ��wavedet.MLII.Pon�õ�1x2271�ľ��󣬾����MLII���ͺ;��󳤶ȿ�����Ҫ��ȡhea�ļ��õ�

%---------------��ȡhea,�����õ��źŵĵ�������--------
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
H{p+1}={(sscanf(z,'%*s %d %*c %d %d %*s',[1,inf])),char(sscanf(z,'%*s %*d %c %*d%*d %*s',[1,inf])),char(sscanf(z,'%*s %*d %*c %*d%*d %s',[1,inf]))};%Ӧ���ǿո��ԭ��
z=fgetl(heaid);
H{p+2}=(sscanf(z,'%s %s ',[1,inf]));
fclose(heaid);
%MILL��V5��λ��
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
    eval(['qrson=wavedet.',leadAtype{1,1},'.QRSon;']);%����ľ�����ֵӦ���ǵڼ�����
    eval(['rpeak=wavedet.',leadAtype{1,1},'.R;']);
    eval(['qrsoff=wavedet.',leadAtype{1,1},'.QRSoff;']);
    eval(['ton=wavedet.',leadAtype{1,1},'.Ton;']);
    eval(['tpeak=wavedet.',leadAtype{1,1},'.R;']);
    eval(['toff=wavedet.',leadAtype{1,1},'.Toff;']);
    %P���Ƿ����û����⣬�͵�ȫ�������ں���
    %���qrsoff��toff�Ƿ���NaN
    qrson=correctNaN(qrson);
        %rpeak=correctNaN(rpeak);
        %ton=correctNaN(ton);
        %tpeak=correctNaN(tpeak);
    qrsoff=correctNaN(qrsoff);
    toff=correctNaN(toff);  %�������Ҫ��
    
    eval(['save ',saveFSpath,num2str(num),'\',qrsonFILENAME,' qrson;']);
    eval(['save ',saveFSpath,num2str(num),'\',qrsoffFILENAME,' qrsoff;']);
    eval(['save ',saveFSpath,num2str(num),'\',toffFILENAME,' toff;']);
end

%--------------------------ECG�˲�-------------------------------
datName=[num2str(num),'.dat'];
datd=fullfile(originPath,datName);
datid=fopen(datd);
A=fread(datid,[3 inf],'uint8');
fclose(datid);
M1H=bitand(A(2,:),15);
M2H=bitshift(A(2,:),-4);
%PRL=bitshift(bitand(A(:,2),8),9);%ΪʲôҪȡ������λ�е����λ,����Ϊ����λ
M(1,:)=bitshift(M1H,8)+A(1,:);%��һ���ź�
M(2,:)=bitshift(M2H,8)+A(3,:);%�ڶ����ź�
D(:,1)=M(1,:)';
D(:,2)=M(2,:)';
clear A;
D_QRSP=medfilt1(D,0.2*frequency); %200ms��ֵ�˲�
D_T=medfilt1(D_QRSP,0.6*frequency); %Ӧ������ֵ�˲���ԭ��
D_T(1,:)=D_T(3,:);% ������������ð��һ�£����������Ӧ������D_QRS��߼�����������
D_T(2,:)=D_T(3,:);
%�е����⣬D_passed��D�Ŀ�ͷ������ֵԶ����R����ֵ��760����330��Դ��D_T

%end
%-------------------��ͼ----------------
t=1:1:650000;
% figure(1)
% plot(t(1:3600),D(1:3600,1),t(1:3600),D_QRSP(1:3600,1),t(1:3600),D_T(1:3600));axis tight;legend('Original','200ms','600ms'); legend('boxoff');
% figure(2)
% subplot(311);plot(t(1:3600),D(1:3600,1));axis tight;ylabel('D');
% subplot(312);plot(t(1:3600),D_QRSP(1:3600,1));axis tight;ylabel('D_QRSP');
% subplot(313);plot(t(1:3600),D_T(1:3600));axis tight;ylabel('D_T');
%--------------------12-tap low-pass filter  û�б���ӣ������Ѿ��������˲�-----------
D_passed=D-D_T; %---��������Ư�ƺ������źţ���������A�͵���B
%plot(t(1:3600),D(1:3600,1),t(1:3600),D_passed(1:3600,1));axis tight;legend('Original','Subtracted Baseline'); legend('boxoff');
%plot(t(646400:650000),D(646400:650000,1),t(646400:650000),D_passed(646400:650000,1));axis tight;legend('Original','Subtracted Baseline'); legend('boxoff');
%ԭʼ�źŵ�ĩβ��һ�����ŵ��µ�,�����ݾ�����������ֵ768,��������Ư�Ƶ�ĩβ������������Ҳ����ֻ��100���ļ�������,��Ϊĩβ�պ���R���յ�
%Ϊ��ȷ��D_passed������NaN,����һ�Σ�����correctNaN����




%------------------˵��---------------------------------
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
%-----------------����wavedet.MLII.Pon--------------------------------------
loadname=[num2str(num),'_ECG_delineation.mat'];
load ([outputPath,loadname]);%�õ�wavedet

%--------------������leadBtype------------------------------------------------------
% eval(['qrson=wavedet.',leadAtype{1,1},'.QRSon;']);%����ľ�����ֵӦ���ǵڼ�����
% eval(['rpeak=wavedet.',leadAtype{1,1},'.R;']);
% eval(['qrsoff=wavedet.',leadAtype{1,1},'.QRSoff;']);
% eval(['ton=wavedet.',leadAtype{1,1},'.Ton;']);
% eval(['tpeak=wavedet.',leadAtype{1,1},'.R;']);
% eval(['toff=wavedet.',leadAtype{1,1},'.Toff;']);
% %P���Ƿ����û����⣬�͵�ȫ�������ں���
% %���qrsoff��toff�Ƿ���NaN
% qrson=correctNaN(qrson);
%     %rpeak=correctNaN(rpeak);
% qrsoff=correctNaN(qrsoff);
%     %ton=correctNaN(ton);
%     %tpeak=correctNaN(tpeak);
% toff=correctNaN(toff);  %�������Ҫ��

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
    annoth=bitshift(A(2,i),-2);%�������ڸ�λ���ڶ����ֽڴ����λ��Ҳ�����������ڵڶ����ֽڵ�ǰ6λ
    if annoth==59
        ANNOT=[ANNOT;bitshift(A(2,i+3),-2)]; %��ʱ��������
        ATRTIME=[ATRTIME;A(1,i+2)+bitshift(A(2,i+2),8)+...
        bitshift(A(1,i+1),16)+bitshift(A(2,i+1),24)]; %����û������ģ�����һ�����ĸ�8λ���һ�������͵�����2^32
        i=i+3; %��������16λ��һ��������i=i+1
    elseif annoth==60
        % nothing to do!
    elseif annoth==61
        % nothing to do!
    elseif annoth==62
        % nothing to do!
    elseif annoth==63 %����10λ��������Ҫ�������ֽ��������10λ������������Ҫ��������һ�����ֽڣ�8λ��
        hilfe=bitshift(bitand(A(2,i),3),8)+A(1,i); %ȡ��10λ
        hilfe=hilfe+mod(hilfe,2);
        i=i+hilfe/2;%�
    else
        ATRTIME=[ATRTIME;bitshift(bitand(A(2,i),3),8)+A(1,i)];
        ANNOT=[ANNOT;bitshift(A(2,i),-2)];
    end
	i=i+1;
end
 ANNOT(length(ANNOT))=ANNOT(end-1);
    ATRTIME_RR=ATRTIME;
ATRTIME= (cumsum(ATRTIME))/frequency;
%---------------------------ֱ�Ӵ�����ATRTIME��ANNOT--------------
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
        pre_RR(end+1)=ATRTIME_RR(i+1,1); %ǰ����������ǰ���������õ������͵��ĸ�������
    else 
        pre_RR(end+1)=ATRTIME_RR(i,1);
    end

    if  i>=(size(ATRTIME_RR,1)-1)
        post_RR(end+1)=ATRTIME_RR(i-1,1);
    else
        post_RR(end+1)=ATRTIME_RR(i+1,1);
    end

    if i<=5 %С��5�������4����5+6+7+8+9 +4+3+2+1+1��
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
%-----------------�̶�����ĵ�ͼ-----------------------------
%ʹ��FP+50ms���飬Ҳ���ǹ̶���������3A,3B,4A,4B
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
%         QRS_3A�Ǻ������еģ�D_passed����������
        QRS_3A(k,s)=D_passed(QRSon+6*s-6,1);
        QRS_3B(k,s)=D_passed(QRSon+6*s-6,2);
    end
    for s=1:8
        T_3A(k,s)=D_passed(Ton+18*s-18,1);
        T_3B(k,s)=D_passed(Ton+18*s-18,2);
    end
end
%�Ѿ��õ�3A,3B���morphology,
%---------------3A,3B end-----------------------------------
%ʹ��mapminmax��dat���й�һ����ֵ��ע����������ǶԷָ����ÿ���������й�һ��
%����FP+50�Ĳ��֣�ֻ�Կ��ڽ�����������Ŵ���
% �����������ź��������ÿ��������ÿ�����ڵ�����������
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
    %-----------��һ��----------------------------------------
    Map_4AQRS=mapminmax(D_4AQRS_Origin);
    Map_4BQRS=mapminmax(D_4BQRS_Origin);
    Map_4AT=mapminmax(D_4AT_Origin);
    Map_4BT=mapminmax(D_4BT_Origin);
    %-----------��һ�� end------------------------------------
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

%-----------------�̶�����ĵ�ͼ end---------------------------
%�������FS3,FS4,FS7,FS8
local_RR=localAverage_RR*ones([size(pre_RR,1) 1]);
FS3=[pre_RR,post_RR,average_RR,local_RR,QRS_3A,T_3A];
FS4=[pre_RR,post_RR,average_RR,local_RR,QRS_4A,T_4A];
FS7=[pre_RR,post_RR,average_RR,local_RR,QRS_3B,T_3B];
FS8=[pre_RR,post_RR,average_RR,local_RR,QRS_4B,T_4B];
%---------------------FS3,FS4,FS7,FS8 end-----------------------------------

%-----------------------�編���ƻ��FS1,FS2,FS5,FS6------------------
%ֻ�����QRSon�ȣ�Heartbeat Interval=[QRSoff-QRSon,Toff-QRSoff,boolean P]
%------------------------1A,1B------------------------
%ʹ��FP+50ms���飬Ҳ���ǹ̶���������3A,3B,4A,4B
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
    %���������˼�飬����ֱ���޸�qrsoff
    %Toff=toff(k);% ����̫������ָĲ�����Toff=Ton+0.35*360;������ͨ��
    Toff=Ton+75;%����һ�ۣ�������70-85
    %------------------------------------------------------------------------------------------------��ʱ��Ĺ���
    
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
    
%         QRS_3A�Ǻ������еģ�D_passed����������
        QRS_1A(k,:)= D_2AQRS_Origin;
        QRS_1B(k,:)=D_2BQRS_Origin;
   
   
        T_1A(k,:)=D_2AT_Origin;
        T_1B(k,:)=D_2BT_Origin;
    
end
%����Heartbeat Interval,������������
heartbeat_1_1=qrsoff-qrson;
heartbeat_1_2=toff-qrsoff;  %��Ҫ��toff����correctNaN
sizeqrson=size(qrson,2);
%sizeATRTIME=size(ATRTIME,1)-subtrahend;
sizeATRTIME=size(ATRTIME,1);
product=sizeqrson-sizeATRTIME;
% ��������heartbeat_1_2;
heartbeat_1=[heartbeat_1_1;heartbeat_1_2]';
heartbeat_test=heartbeat_1;%����˵��heartbeat_test����NaN
for pk=1:product
    heartbeat_1(end,:)=[];
end

%pflag=ones(size(qrson,2),1);
%pflag=ones(size(ATRTIME,1)-subtrahend,1);
pflag=ones(size(ATRTIME,1),1);
heartbeat_1=[heartbeat_1,pflag];

%�Ѿ��õ�1A,1B���morphology,
%---------------1A,1B end-----------------------------------
%����1A��2A�飬�ڲ�����ʱ��Ҫ��inerp1
%----------------------2A,2B-----------------------------------
%for k=(1):(size(ATRTIME,1)-subtrahend)
for k=(1):(size(ATRTIME,1))
%for k=1:(size(qrson,2))
    QRSon=qrson(k);
    QRSoff=QRSon+30;
    Ton=QRSoff;
    %Toff=toff(k);
    Toff=Ton+75;%-----------------------------------------------------------------��ʱ��Ĺ���
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
%     ����Ķ���
%     D_4AQRS_Origin=D_passed(QRSon:QRSoff,1);
%     D_4BQRS_Origin=D_passed(QRSon:QRSoff,2);
%     D_4AT_Origin=D_passed(Ton:Toff,1);
%     D_4BT_Origin=D_passed(Ton:Toff,2);
    %-----------��һ��----------------------------------------
    Map_4AQRS=mapminmax(D_4AQRS_Origin);
    Map_4BQRS=mapminmax(D_4BQRS_Origin);
    Map_4AT=mapminmax(D_4AT_Origin);
    Map_4BT=mapminmax(D_4BT_Origin);
    %-----------��һ�� end------------------------------------
    
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



%�벻ͨ����ΪʲôFS1,2,5,6����NaN��
%��������heartbeat_1
FS1=[pre_RR,post_RR,average_RR,local_RR,heartbeat_1,QRS_1A,T_1A];
FS5=[pre_RR,post_RR,average_RR,local_RR,heartbeat_1,QRS_1B,T_1B];
FS2=[pre_RR,post_RR,average_RR,local_RR,heartbeat_1,QRS_2A,T_2A];
FS6=[pre_RR,post_RR,average_RR,local_RR,heartbeat_1,QRS_2A,T_2A];

% FS3=[pre_RR,post_RR,average_RR,local_RR,QRS_3A,T_3A];
% FS4=[pre_RR,post_RR,average_RR,local_RR,QRS_4A,T_4A];
% FS7=[pre_RR,post_RR,average_RR,local_RR,QRS_3B,T_3B];
% FS8=[pre_RR,post_RR,average_RR,local_RR,QRS_4B,T_4B];
%------------------------------------------------------
%��Ӧ���ǿ����˰ɣ�����������
%���ˣ�
%------------��ANNOT��ͷȥβ�����---------------������ô��ͷȥβ��ecgkit��annot��һ��
% ANNOT(1:subtrahend/2,:)=[];
% ANNOT(end-(subtrahend/2-1):end,:)=[];
%saveFSpath='E:\matlab\0402\FS\';
for spk=1:8
    FSfilename=[num2str(num),'FS',num2str(spk),'.mat'];
    eval(['save ',saveFSpath,num2str(num),'\',FSfilename,' FS',num2str(spk),';']);
end
annotFILENAME=[num2str(num),'ANNOT','.mat'];
eval(['save ',saveFSpath,num2str(num),'\',annotFILENAME,' ANNOT']);
end  %��ǰ���if��end



end

