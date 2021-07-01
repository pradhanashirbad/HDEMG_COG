function y = bandpass_filter(Data)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
%% Filter the signal using 4th order butterworth filter
n=size(Data,2);
[b a] = butter(2,[0.01/(2/2) 0.45/(2/2)],'bandpass');
for j=1:n
    x_filtered(:,j)=filter(b,a,Data(:,j));
end
y=x_filtered;
end

