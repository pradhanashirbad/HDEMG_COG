function y = update_single(Data,channel,time)
try
if nargin == 2
    time = 1:length(Data);
end

columntotal=size(Data,2);
if columntotal==65
   Data=Data(:,2:65);
end

plot(time,Data(:,channel))
title(['raw EMG from channel ' num2str(channel) ' [mV]'])
xlabel('sample')
ylabel('EMG [mV]')
y=Data;

catch
    disp("Enter a valid channel number")
end
end



