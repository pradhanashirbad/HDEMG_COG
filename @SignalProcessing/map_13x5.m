function [y1,y2] = map_13x5(obj,Data_rms_maps)
y1=0; y2=0;
xnum=0;ynum=0;
ncols = size(Data_rms_maps,2);
if ~(size(Data_rms_maps,2)>55)
    return
end

cla
%map figure

%Data_rms_maps(50:60)= temp;
% one z matrix for each epoch
% z = [Data_rms_maps(1:1:13); Data_rms_maps(14:1:26) ;   Data_rms_maps(27:1:39)...
%     ; Data_rms_maps(40:1:52) ; Data_rms_maps(53:1:65) ]; 
% z3=transpose(z);
for i=1:5
    z(:,i) = [Data_rms_maps(1+(i-1)*ncols/5:1:i*ncols/5)'];
end

%z = [Data_rms_maps(1:1:7)' Data_rms_maps(8:1:14)' Data_rms_maps(15:1:21)' Data_rms_maps(22:1:28)']; 
for i=1:5
    xnum = xnum + (i*(sum(z(:,i))));
end
for j=1:ncols/5
    ynum = ynum + (j*(sum(z(j,:))));
end

xcg = xnum/ sum(sum(z(:,1:5)));
ycg = ynum/ sum(sum(z(:,1:5)));
y1 = xcg;
y2 = ycg;
% [b,i]=max(z,[],'all')
% disp(max(z,[],'all'))

%handles
% Plot the 2D map
hold on
[x,y]=meshgrid(1:5,1:ncols/5);
% % pbaspect manual
% % pbaspect([4 6 1])
%ax=gca; % gca get handle to current axix
pcolor(x,y,z) % a pseudocolor or "checkerboard" plot of matrix z on the grid defined by x and y.
% The values of the elements of c specify the color in each cell of the plot.
colormap(jet)

if min(z,[],"all")<max(z,[],"all")
    caxis([min(z,[],"all"), max(z,[],"all")]);
else
    caxis([min(z,[],"all"), min(z,[],"all")+1]);
end
axis equal tight
%axis off
hold on
% plot(x,y,'ko','LineWidth',1);
%highlight the channels used to compute the diff feature (20 and 21 now)
%plot(2,4,'ko','LineWidth',3);

% view(0,90)
shading interp %interpolate the points in the map
hold on
xlim([1 5])
ylim([1 ncols/5])
%build the title
%title('Heat Map - Amplitude 32');

plot(xcg,ycg,'x','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','k')
plot(1,1,'kx','LineWidth',3,'MarkerSize',20)
xticks([1:5])
yticks([1:ncols/5])
a=gca;
a.XRuler.TickLabelGapOffset = -3;
a.YRuler.TickLabelGapOffset = -1;

hcb=colorbar();

end

