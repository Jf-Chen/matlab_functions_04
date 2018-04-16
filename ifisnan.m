function tempqrs=ifisnan(k,tempqrs)%必须在运行的时候就修改元数据，不然在出现连续出现4个NaN时会出现不单调递增的情况
%IFISNAN k是位置，Ton是输出，qrsoff是某个矩阵，2771x1
%   此处显示详细说明
i=1;newint=NaN;
% while isnan(newint)  %事实证明，取均值不行
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
        tempqrs(1,k)=tempqrs(1,k-1)+newint;  %必须考虑到连续都是NaN的情况，从第一个开始就是NaN
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

