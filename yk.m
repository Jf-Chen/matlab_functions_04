function Yk = yk(uk,sigma,k,x)
%YK �����k��ĺ�������е�Yk
%   �˴���ʾ��ϸ˵��
if k<5
    K=10/41;
else
    K=1/41;
end
%δת��֮ǰuk��1x27,x��1x27,һ��uk=[],�ͻ��ж�
if size(uk,1)==0
    pause();
end
uk=uk';
x=x';
% Yk=-(1/2)*uk'*inv(sigma)*uk+uk'*inv(sigma)*x+log(K);%�Ҳ�����eΪ��
 Yk=-(1/2)*uk'*inv(sigma)*uk+uk'*inv(sigma)*x+log(K);
end

