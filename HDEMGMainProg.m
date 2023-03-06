classdef HDEMGMainProg < SignalProcessing
    % class HDEMGMainProg
    %
    % Author: Ashirbad Pradhan, 2023.
    %
    %

    properties(GetAccess = 'public', SetAccess = 'public', Transient = true) % Read-only access from public, but do NOT save
        hSettings;
        hLayout;
        fileName;
        rawEMG;
        time;
        Data;
        auxData;
        filteredEMG;
        bipolarEMG;
        processedEMG;
        normEMG;
        layout_select;
        diff_channel=[11, 11];
        filterFlag;
        lastIndex = 0;
        isMVC;
        maxVal =[1,1,1,1];
        grid_config;
        cci_grids = [];
        bipolarsize = [];
        mapper ;
        bipolar_converter =[];
        useLong = [0,0,0,0]; %store the index of 13x5 grid, used while loading defaults
    end

    methods(Access = public)

        function obj = HDEMGMainProg(varargin)
            % Intitalize the Controller object and make sure, that a handle to the
            % MainFigure is passed. After passing this handle, a new
            % window (hUserWindow) will be created, that will be the
            % feedback/instruction window for the subject
            obj.hSettings = HDEMG_Settings(obj);
        end
        function obj = load_defaults(obj)
            config;
            obj.grid_config = GRID_CONFIG;
            obj.grid_config(find(obj.useLong)) = 65;% update 64 to 65 in case of long grid
            obj.f_samp = F_SAMP;
            obj.epochsize = WINDOW_SIZE_MS*obj.f_samp/1000;
        end

        function [Data, obj] = load_data(obj)
            % Intitalize the Controller object and make sure, that a handle to the
            % MainFigure is passed. After passing this handle, a new
            name_ext = strsplit(obj.fileName,'.');
            if strcmp(name_ext{2},'mat')
                load(obj.fileName)
                obj.Data = Data;
                obj.rawEMG=Data(:,1:64);
                obj.time=Time;
            elseif strcmp(name_ext{2},'csv')
                Data=csvread(obj.fileName);
                obj.Data = Data;
                obj.rawEMG=Data(:,2:65);
                obj.time=Data(:,1);
            end
%             obj.filteredEMG = obj.rawEMG;
            handles_settings = guidata(obj.hSettings);
            %validate
            if size(Data,2) < sum(handles_settings.grid_config)
                disp(strcat("Loadfile Error: There are supposed to be ",num2str(sum(handles_settings.grid_config)), " columns"));
                Data = [];
            end           
            guidata(obj.hSettings,handles_settings);
        end

        function obj = get_entries_from_settings(obj)
            handles_settings = guidata(obj.hSettings);
            %get layout values
            obj.layout_select = get(handles_settings.popup_layout,'Value');            
            
            %normalization values
            if get(handles_settings.btn_norm3,'Value')||get(handles_settings.btn_norm2,'Value')%no normalization
                obj.isMVC = false;
                obj.maxVal = [1,1,1,1];
            end
            if get(handles_settings.btn_norm1,'Value')%normalize to MVC
                obj.isMVC = true;
                obj.maxVal = [1,1,1,1];
                for i =1:length(obj.grid_config)
                    obj.maxVal(i) = str2double(get(handles_settings.edt_mvcval(i),'String'));                    
                end
                disp(obj.maxVal)
            end            
            guidata(obj.hSettings,handles_settings);
            %check cci
            if get(handles_settings.chk_cci,'Value')
                %validate cci settings
                val1 = get(handles_settings.popup_agon,'Value');
                val2 = get(handles_settings.popup_antagon,'Value');
                if isequal(val1,val2)
                    disp("WARNING: Using same grids for CCI");
                    obj = []; % force an error
                elseif ~isequal(handles_settings.grid_config(val1),handles_settings.grid_config(val2))
                    disp("ERROR: Grids are of unequal length")
                    obj = []; % force an error
                else
                    obj.cci_grids = [val1, val2];
                    guidata(obj.hSettings,handles_settings);
                end 
            else
                guidata(obj.hSettings,handles_settings); % update obj in handles
            end        
        end

        function obj = validate_layout(obj)
            switch obj.layout_select
                case 1 %32 x 2
                    index = find(obj.grid_config == 32);
                    if ~(length(index)==2)%validation
                        obj=0;%force an error
                    end
                    obj.bipolarsize = [28,28];  
                    obj.bipolar_converter{1}= @bipolar_converter_8x4;
                    obj.bipolar_converter{2}= @bipolar_converter_8x4;
                    obj.mapper{1} = @mapper_8x4;
                    obj.mapper{2} = @mapper_8x4;
                case 2 %64x1 long
                    index = find(obj.grid_config == 64);
                    if isempty(index) && ~find(obj.useLong,1)
                        obj=0;% force an error
                    end
                    obj.useLong(index)=1;% stores the original entry, doesnt affect if layout is closed
                    obj.grid_config(find(obj.useLong)) = 65;
                    obj.bipolarsize = 60;                    
                    if ~(size(obj.rawEMG,2)==65)
                        extra_entry = mean(obj.rawEMG(:,[1,13,14]),2);
                        obj.rawEMG = [extra_entry obj.rawEMG];
                    end
                    obj.bipolar_converter{1}= @bipolar_converter_13x5;
                    obj.mapper{1} = @mapper_13x5;
                case 3
                    index = find(obj.grid_config == 64, 1);
                    if isempty(index)
                        obj=0;% force an error
                    end
                    obj.bipolarsize = 56;   
                    obj.bipolar_converter{1}= @bipolar_converter_8x8;
                    obj.mapper{1} = @mapper_8x8;
                otherwise
                    disp('choose another one')
            end
        end

        function [filterFlag,bipolarFlag,featureVal] =  get_processing_settings(obj)
            if isempty(obj.hSettings)
                obj.hSettings=HDEMG_Settings(obj);
                disp('Opening Settings again')
                return
            end
            handles_settings = guidata(obj.hSettings);
            if isempty(obj.hLayout)% get feature value
                featureVal = 1;%use RMS in case of no settings
            else
                handles_layout = guidata(obj.hLayout);
                featureVal = get(handles_layout.popup_feature,'Value');
            end
            if get(handles_settings.chk_bpfilter,'Value')% get band pass filter state
                filterFlag = true;
            else
                filterFlag = false;
            end
            if get(handles_settings.chk_bipolar,'Value')
                bipolarFlag = true;
            else
                bipolarFlag = false;
            end
        end


        function obj = sigpro(obj, filterFlag, bipolarFlag, featureVal)
            obj.bipolarEMG = [];
            grid_config_cumsum = cumsum(obj.grid_config);
            if filterFlag
                obj.filteredEMG = bp_filter(obj,obj.rawEMG);
            end
            if bipolarFlag
                for i = 1:length(obj.grid_config)
                    index_for_data = grid_config_cumsum(i) - obj.grid_config(i) + 1 : grid_config_cumsum(i);
                    obj.bipolarEMG = [obj.bipolarEMG obj.bipolar_converter{i}(obj,obj.filteredEMG(:,index_for_data))];
                    obj.grid_config(i) = obj.bipolarsize(i);
                end
            else
                obj.bipolarEMG = obj.filteredEMG;
            end
            switch featureVal
                case 1 %RMS
                    obj.processedEMG = get_rms(obj,obj.bipolarEMG);
                case 2 %MDF
                    obj.processedEMG = get_mdf(obj,obj.bipolarEMG);
                case 3 %ARV
                    obj.processedEMG = get_arv(obj,obj.bipolarEMG);
                otherwise
                    disp('invalid entry')
            end
        end

        function obj = load_layout(obj)
            if isempty(obj.hSettings)
                obj.hSettings=HDEMG_Settings(obj);
                disp('Error: Restart program')
                return
            end
            handles_settings = guidata(obj.hSettings);

            % load layout
            if isempty(obj.hLayout)
                obj.hLayout=HDEMG_Layout(obj, length(obj.grid_config));
                handles_layout = guidata(obj.hLayout);
            end
            %remove unwanted entries
            switch length(obj.grid_config)
                case 1
                    set(handles_layout.txt_gridnum(2:end),'Visible','Off')
                    set(handles_layout.edt_mapmax(2:end),'Visible','Off')
                    set(handles_layout.txt_maxval(2:end),'Visible','Off')
                case 2
                    set(handles_layout.txt_gridnum(3:end),'Visible','Off')
                    set(handles_layout.edt_mapmax(3:end),'Visible','Off')
                    set(handles_layout.txt_maxval(3:end),'Visible','Off')      
            end

            %update info
            set(handles_layout.edt_filename, 'String', obj.fileName);

            %set aux data
            if get(handles_settings.chk_aux,'Value')
                obj.auxData=obj.Data(:,str2double(get(handles_settings.edt_aux,'String')));
            else
                obj.auxData=obj.Data(:,1);%initialize 1D array
                obj.filteredEMG = bp_filter(obj,obj.rawEMG);
                obj.processedEMG = get_rms(obj, obj.filteredEMG,1);
                obj.auxData = mean(obj.processedEMG(:,randperm(size(obj.processedEMG,2),1)),2); % when without aux, use EMG data
            end

            %load aux
            axes(handles_layout.axs_aux)
            plot(obj.time,obj.auxData); xlim([0,obj.time(end)]);
            hold on
            plot(obj.time(floor(length(obj.time)/2)),obj.auxData(floor(length(obj.time)/2)),'o','LineWidth',2,'MarkerSize',5,'MarkerEdgeColor','k');
            hold off
            %update second window
            guidata(obj.hLayout, handles_layout);
        end

        function [results_vector,obj] = update_layout(obj,index)
            if isempty(index)
                index = round(length(obj.time)/2);
            end            
            obj.lastIndex = index;
            if isempty(obj.hLayout)
                obj.hLayout=HDEMG_Layout(obj, length(obj.grid_config));
                return
            end
            handles_layout = guidata(obj.hLayout);            
            data = obj.processedEMG;            
            %update map
            index_for_map = round(index/10);
            grid_config_cumsum = cumsum(obj.grid_config);            
            maxval = [0,0,0,0]; xcg = [0,0,0,0]; ycg = [0,0,0,0];
            for i = 1:length(obj.grid_config)
                axes(handles_layout.pax(i))
                %all rows - selected columns normalize  
                index_for_data = grid_config_cumsum(i) - obj.grid_config(i) + 1 : grid_config_cumsum(i);
                norm_data = data(:,index_for_data)./obj.maxVal(i);
                disp(strcat('Normalization: Divide by:',num2str(obj.maxVal(i))));
                %use this to calculate normalized max of trial
                maxval(i) = round(max(norm_data,[],"all"),2);
                %use index to obtain data to plot
                mapData = data(index_for_map,index_for_data);
                [xcg(i),ycg(i)]=obj.mapper{i}(obj,mapData);
                %calculate max
                %update text
                set(handles_layout.txt_maxval(i), 'String', num2str(maxval(i)));
            end
            %update cursor
            axes(handles_layout.axs_aux)
            hold on
            plot(obj.time(index),obj.auxData(index),'o','LineWidth',2,'MarkerSize',5,'MarkerEdgeColor','k')
            hold off

            %get results
            filename = get(handles_layout.edt_filename,'String');
            contents = cellstr(get(handles_layout.popup_feature,'String'));
            featurename = contents{get(handles_layout.popup_feature,'Value')};
            results_vector = [{filename},{featurename},{index},{obj.epochsize*1000/obj.f_samp},get_results(obj,data,index,xcg,ycg,maxval)];       
        end

        function y_vector = get_results(obj,data,index,xcg,ycg,maxval)
            y_vector = {}; data_cci=[];
            grid_config_cumsum = cumsum(obj.grid_config);   
            for i = 1:length(obj.grid_config)
                index_for_map = round(index/10);
                index_for_data = grid_config_cumsum(i) - obj.grid_config(i) + 1 : grid_config_cumsum(i);
                datanum = data(index_for_map,index_for_data);
                diff = obj.diff_channel(i);
                result_from_metrics = get_metrics_rms(obj,datanum,diff);
                y_vector = [y_vector,strcat('grid',num2str(i),': ',num2str(size(datanum,2))),num2cell(result_from_metrics),num2cell(maxval(i)),num2cell(xcg(i)),num2cell(ycg(i))];
            end
            if ~isempty(obj.cci_grids)
                for i = 1:length(obj.cci_grids)
                    index_for_data_cci = grid_config_cumsum(obj.cci_grids(i)) - obj.grid_config(obj.cci_grids(i)) + 1 : grid_config_cumsum(obj.cci_grids(i));
                    data_cci(i,:) = data(index_for_map,index_for_data_cci);
                end
                cci_val = get_metrics_cci(obj,data_cci(1,:),data_cci(2,:));
            else
                cci_val = 0;
            end
            y_vector = [y_vector, num2cell(cci_val)];   
        end

        function change_minmax(obj)
            handles_layout = guidata(obj.hLayout);
            cmin = str2double(get(handles_layout.edt_mapmin,'String'));
            cmaxs = [1,1,1];
            for i = 1:length(obj.grid_config)
                cmaxs(i) = str2double(get(handles_layout.edt_mapmax(i),'String'));
                axes(handles_layout.pax(i))
                caxis([cmin, cmaxs(i)]);
            end
        end
    end
end
