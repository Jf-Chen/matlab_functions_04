function [returnP] = sumP(P1,P2,P3,P4,P5,P6,P7,P8)
%SUMP P1��FS1��1x5���󣬴�2271x5�������,pN�Ǽ������ۺϸ���
%   �˴���ʾ��ϸ˵��
addall=[];
for k=1:5 %P1��1x5�Ľṹ���Ѻ�ʵ��
    addall(end+1)=P1(1,k)*P2(1,k)*P3(1,k)*P4(1,k)*P5(1,k)*P6(1,k)*P7(1,k)*P8(1,k);
end
Sum=sum(addall,2);%addallӦ���ǣ�δ��ʵ��1x5�Ľṹ
pN=addall(1,1)/Sum;
pS=addall(1,2)/Sum;
pV=addall(1,3)/Sum;
pF=addall(1,4)/Sum;
pQ=addall(1,5)/Sum;
returnP=[pN,pS,pV,pF,pQ];


end

