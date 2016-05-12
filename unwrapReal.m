function[phaseOut] = unwrapReal(phaseIn)

y_peakFind = phaseIn;
kk = 1;
for i = 2:length(y_peakFind)
    a = y_peakFind(i-1);
    b = y_peakFind(i);
    if abs(a - b) > 1.0
        cuSum(:,kk) = [zeros(i-1,1);(a - b)*ones(length(y_peakFind)-i,1)];
        kk = kk + 1;
    end
end
if kk ~= 1
    for i = 1:kk-1
        phaseOut = phaseIn + [cuSum(:,i);cuSum(end,i)];
    end
else
    phaseOut = phaseIn;
end