clear 
part=1;
side='Right';
side_code=1;
speed=[60 90 120];
value=[];
for part=13
    for ispeed=1:3
        cg=[];
        try
            filename=strcat('P0',num2str(part)," ",num2str(speed(ispeed))," Degrees per second T1 ",side,'.csv_0%_cog.csv')
            cg=csvread(filename);
        catch
            filename=strcat('P0',num2str(part)," ",num2str(speed(ispeed))," Degrees per second T2 ",side,'.csv_0%_cog.csv')
            cg=csvread(filename);
        end
        xcg_mean=mean(cg(:,1));
        ycg_mean=mean(cg(:,2));
        xcg_var=var(cg(:,1));
        ycg_var=var(cg(:,2));
        xcg_range=range(cg(:,1));
        ycg_range=range(cg(:,2))
        value=[value; part side_code speed(ispeed) xcg_mean ycg_mean xcg_var ycg_var xcg_range ycg_range];
    end
end
