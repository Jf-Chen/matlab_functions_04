function [returnP] = sumP(P1,P2,P3,P4,P5,P6,P7,P8)
%SUMP P1是FS1的1x5矩阵，从2271x5分离而来,pN是计算后的综合概率
%   此处显示详细说明
addall=[];
for k=1:5 %P1是1x5的结构（已核实）
    addall(end+1)=P1(1,k)*P2(1,k)*P3(1,k)*P4(1,k)*P5(1,k)*P6(1,k)*P7(1,k)*P8(1,k);
end
Sum=sum(addall,2);%addall应该是（未核实）1x5的结构
pN=addall(1,1)/Sum;
pS=addall(1,2)/Sum;
pV=addall(1,3)/Sum;
pF=addall(1,4)/Sum;
pQ=addall(1,5)/Sum;
returnP=[pN,pS,pV,pF,pQ];


end

