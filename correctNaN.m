%function newqrson=correctNaN(qrson)
function qrson=correctNaN(qrson)
%CORRRECTNAN 此处显示有关此函数的摘要
%   此处显示详细说明
%newqrson=3*ones([1,size(qrson,2)]);
for ck=1:size(qrson,2)
    if isnan(qrson(1,ck))
        %newqrson(1,ck)=ifisnan(ck,qrson);
    
        qrson=ifisnan(ck,qrson);
    else
        %newqrson(1,ck)=qrson(1,ck);
        %nothing to do
    end
end
logi=0;

end

