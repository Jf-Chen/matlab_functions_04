function [] = baselineCorrect(originPath,num)
%BASELINECORRECT ��������Ư��
%   �˴���ʾ��ϸ˵��
originPath='E:\matlab\0402\MIT-BIH Arrhythmia Database';


frequency=360;
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
D_passed=D-D_T; %---��������Ư�ƺ������źţ���������A�͵���B
%plot(t(646400:650000),D(646400:650000,1),t(646400:650000),D_passed(646400:650000,1));axis tight;legend('Original','Subtracted Baseline'); legend('boxoff');
%����������ô����ECG delineation?,Ҫ���Ͳ�ȥ������Ư���ˣ�����ȥ����һ�¸�ʽ����matlab��ʽ��һ��
end

