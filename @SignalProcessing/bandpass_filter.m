function y = bandpass_filter(obj,Data,fs)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
useTranspose = false;
if size(Data,2)>size(Data,1)
    useTranspose = true;
    Data=Data.';
end
x_filtered= Data;
%% Filter the signal using 4th order butterworth filter
n=size(Data,2);
[b, a] = butter(2,[20 450]*2/fs,'bandpass');
for j=1:n
    x_filtered(:,j)=filter(b,a,Data(:,j));
end
if useTranspose
    y=x_filtered.';    
else
    y=x_filtered;
end
