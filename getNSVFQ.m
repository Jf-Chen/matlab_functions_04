function [N,S,V,F,Q] = getNSVFQ(FS9,ANNOT)
%GETNSVFQ �˴���ʾ�йش˺�����ժҪ
%   ��һ����ֻ�������뵥��100.dat��FS1(8ȡ1),��ANNOT,���N,S,V,F,Q,��Ϊ��С�ĺ���������ĵط�ȥ�ϲ�
%   FS9�ǵ����ļ���ĳһ��FS,ANNOT�Ƕ�Ӧ��ANNOT,���NSVFQ��FS9��Ӧ����ʽԤ֧��ͬ��ֻ�ǰ����������Ͳ����
%   ��100.datΪ����FS1��2271x27,FS4��2271x22,ANNOT��2271x1,��ֵ����������������
N=[];S=[];V=[];F=[];Q=[];
for k=1:size(ANNOT,1)  %�Ѿ���getFSfromSingle�б���ͷȥβ��
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

