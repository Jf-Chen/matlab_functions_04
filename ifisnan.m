function tempqrs=ifisnan(k,tempqrs)%���������е�ʱ����޸�Ԫ���ݣ���Ȼ�ڳ�����������4��NaNʱ����ֲ��������������
%IFISNAN k��λ�ã�Ton�������qrsoff��ĳ������2771x1
%   �˴���ʾ��ϸ˵��
i=1;newint=NaN;
% while isnan(newint)  %��ʵ֤����ȡ��ֵ����
%     value1=qrsoff(1,k-i);
%     value2=qrsoff(1,k+i);
%     qrsoff(1,k)=round((value1+value2)/2);
%     newint=qrsoff(1,k);
%     i=i+2;
% end
value1=NaN;value2=NaN;
while isnan(newint)
    i1=0;i2=1;
    value1=tempqrs(1,i1+i);
    
    while isnan(value1)
        i1=i1+1;
        value1=tempqrs(1,i1+i);
    end
    value2=tempqrs(1,i1+i2+i);
    while isnan(value2)
        i2=i2+1;
        if (i1+i2+i)>=size(tempqrs,2)
            logi3=0;
        end
        value2=tempqrs(1,i1+i2+i);
    end
    
    newint=(value2-value1)/(i2);
    logi2=0;
    if k>=size(tempqrs,2)
        logi3=0;
    end
    if k>1
        tempqrs(1,k)=tempqrs(1,k-1)+newint;  %���뿼�ǵ���������NaN��������ӵ�һ����ʼ����NaN
    else 
        tempqrs(1,k)=tempqrs(1,i+i1)-newint*(i+i1-k);
    end
    newint=tempqrs(1,k);
    i=i+1;
    if i>=size(tempqrs,2)
        logi3=0;
    end
end

logi=0;

end

