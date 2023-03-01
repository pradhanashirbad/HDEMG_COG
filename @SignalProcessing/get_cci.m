function CCI = get_cci(obj,Data_rms_1,Data_rms_2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
                
ncols = size(Data_rms_1,2);
sum = 0;
for i=1:ncols
    sum = sum + (Data_rms_1(i)./Data_rms_2(i));
end
CCI = sum/ncols;
end