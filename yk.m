function Yk = yk(uk,sigma,k,x)
%YK 计算第k类的后验概率中的Yk
%   此处显示详细说明
if k<5
    K=10/41;
else
    K=1/41;
end
%未转置之前uk是1x27,x是1x27,一旦uk=[],就会中断
if size(uk,1)==0
    pause();
end
uk=uk';
x=x';
% Yk=-(1/2)*uk'*inv(sigma)*uk+uk'*inv(sigma)*x+log(K);%我猜是以e为底
 Yk=-(1/2)*uk'*inv(sigma)*uk+uk'*inv(sigma)*x+log(K);
end

