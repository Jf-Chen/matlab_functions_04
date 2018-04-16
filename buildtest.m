function test = buildtest(testC)
%BUILDTEST used to find NaN
%   testCÄ¬ÈÏÎª¶şÎ¬¾ØÕó
testCsize1=size(testC,1);
testCsize2=size(testC,2);
test=[];
for tci1=1:testCsize1
    for tci2=1:testCsize2
        if isnan(testC(tci1,tci2))
            test(end+1,:)=[tci1 tci2];
        end
    end
end
end

