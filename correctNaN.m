%function newqrson=correctNaN(qrson)
function qrson=correctNaN(qrson)
%CORRRECTNAN �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
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

