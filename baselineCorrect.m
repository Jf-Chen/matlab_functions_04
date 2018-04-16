function [] = baselineCorrect(originPath,num)
%BASELINECORRECT 消除基线漂移
%   此处显示详细说明
originPath='E:\matlab\0402\MIT-BIH Arrhythmia Database';


frequency=360;
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
D_passed=D-D_T; %---消除基线漂移后的振幅信号，包括导联A和导联B
%plot(t(646400:650000),D(646400:650000,1),t(646400:650000),D_passed(646400:650000,1));axis tight;legend('Original','Subtracted Baseline'); legend('boxoff');
%可是这样怎么传给ECG delineation?,要不就不去除基线漂移了，或者去除后换一下格式，用matlab格式试一下
end

