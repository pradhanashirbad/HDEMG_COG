function [] = map_print(Data,~,~)
min=0;
max=0.1;
nchannels=size(Data,2);
nlength=size(Data,1);
factor=ceil(nlength/100);
for j = 1:ncolumns %for every channel
        Data_rms_maps(:,j) = rms(Data(:,j),factor,0,1); %  RMS using an epoch length of 'epoch_ms' ms
        %Data_rms is a vector in which each column corresponds to the rms
        %vector of each channel
        % % Data_mdf(:,j) = mdf(Data(:,j),handles.epoch_ms,handles.epoch_ms-1,1);
    end
%map figure


%temp = Data_rms_maps(49:59);


%Data_rms_maps(50:60)= temp;
% one z matrix for each epoch
z = [Data_rms_maps(1:1:nchannels)]; 

%handles
% Plot the 2D map
hold on
[x,y]=meshgrid(1:nchannels,1);
%ax=gca; % gca get handle to current axix
pcolor(x,y,z) % a pseudocolor or "checkerboard" plot of matrix z on the grid defined by x and y.
% The values of the elements of c specify the color in each cell of the plot.
colormap(jet)
caxis([min max])
axis equal tight
%axis off
hold on
%plot(x,y,'ko','LineWidth',1);
%highlight the channels used to compute the diff feature (20 and 21 now)
%plot(2,4,'ko','LineWidth',3);

view(0,90)
%shading interp %interpolate the points in the map
%hold on
%build the title
title('Heat Map - Amplitude');
hcb=colorbar();

end

