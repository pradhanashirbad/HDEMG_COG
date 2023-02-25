function [y1,y2] = map_8x4(Data_rms_maps)
y1=0; y2=0;
xnum=0;ynum=0;
ncols = size(Data_rms_maps,2);
if ~(size(Data_rms_maps,2)==32||size(Data_rms_maps,2)==28)
    return
end

cla
%map figure

%Data_rms_maps(50:60)= temp;
% one z matrix for each epoch
for i=1:4
    z(:,i) = [Data_rms_maps(1+(i-1)*ncols/4:1:i*ncols/4)'];
end
%z = [Data_rms_maps(1:1:7)' Data_rms_maps(8:1:14)' Data_rms_maps(15:1:21)' Data_rms_maps(22:1:28)']; 
for i=1:4
    xnum = xnum + (i*(sum(z(:,i))));
end
for j=1:ncols/4
    ynum = ynum + (j*(sum(z(j,:))));
end

xcg = xnum/ nansum(nansum(z(:,1:4)));
ycg = ynum/ nansum(nansum(z(:,1:4)));
y1 = xcg;
y2 = ycg;


%handles
% Plot the 2D map
hold on
[x,y]=meshgrid(1:4,1:ncols/4);
% % pbaspect manual
% % pbaspect([4 6 1])
%ax=gca; % gca get handle to current axix
pcolor(x,y,z) % a pseudocolor or "checkerboard" plot of matrix z on the grid defined by x and y.
% The values of the elements of c specify the color in each cell of the plot.
colormap(jet)

caxis([min(z,[],"all"), max(z,[],"all")]);
axis equal tight
%axis off
hold on
% plot(x,y,'ko','LineWidth',1);
%highlight the channels used to compute the diff feature (20 and 21 now)
%plot(2,4,'ko','LineWidth',3);

% view(0,90)
shading interp %interpolate the points in the map
hold on
xlim([1 4])
ylim([1 ncols/4])
%build the title
%title('Heat Map - Amplitude 32');

plot(xcg,ycg,'x','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','k')
% plot(5,1:7,'kx','LineWidth',3,'MarkerSize',20)

hcb=colorbar();

end

