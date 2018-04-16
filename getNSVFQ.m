function [N,S,V,F,Q] = getNSVFQ(FS9,ANNOT)
%GETNSVFQ 此处显示有关此函数的摘要
%   这一函数只用来输入单个100.dat的FS1(8取1),和ANNOT,输出N,S,V,F,Q,作为最小的函数，到别的地方去合并
%   FS9是单个文件的某一个FS,ANNOT是对应的ANNOT,输出NSVFQ与FS9对应，格式预支相同，只是按照心跳类型拆分了
%   以100.dat为例，FS1是2271x27,FS4是2271x22,ANNOT是2271x1,数值内容是心跳类型码
N=[];S=[];V=[];F=[];Q=[];
for k=1:size(ANNOT,1)  %已经在getFSfromSingle中被掐头去尾了
    if ANNOT(k,1)==1||ANNOT(k,1)==2||ANNOT(k,1)==3||ANNOT(k,1)==34||ANNOT(k,1)==11
        N(end+1,:)=FS9(k,:);
    end
    if ANNOT(k,1)==8||ANNOT(k,1)==4||ANNOT(k,1)==7||ANNOT(k,1)==9
        S(end+1,:)=FS9(k,:);
    end
    if ANNOT(k,1)==5||ANNOT(k,1)==10
        V(end+1,:)=FS9(k,:);
    end
    if ANNOT(k,1)==6
        F(end+1,:)=FS9(k,:);
    end
    if ANNOT(k,1)==12||ANNOT(k,1)==38||ANNOT(k,1)==13
        Q(end+1,:)=FS9(k,:);
    end
end

% logi=0;


end

