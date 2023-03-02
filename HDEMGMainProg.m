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
        n_plots;
        layout_select;
        diff_channel=[11, 11];
        filterFlag;
        bipolarFlaf;
        lastIndex = 0;
        isMVC;
        maxVal =[1,1,1];
        grid_config;
        cci_grids = [];
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
            obj.filteredEMG = obj.rawEMG;
            handles_settings = guidata(obj.hSettings);
            %validate
            if size(Data,2) < sum(handles_settings.grid_config)*32
                disp(strcat("Loadfile Error: There are supposed to be ",num2str(sum(handles_settings.grid_config)*32), " columns"));
                Data = [];
            end           
            guidata(obj.hSettings,handles_settings);


        end
        function obj = get_entries_from_settings(obj)
            handles_settings = guidata(obj.hSettings);
            obj.layout_select = get(handles_settings.popup_layout,'Value');
            switch obj.layout_select
                case 1 %32 x 2
                    obj.n_plots = 2;
                case 2
                    disp('work in progress try later')
                otherwise
                    disp('choose another one')
            end
            %normalization values
            if get(handles_settings.btn_norm3,'Value')||get(handles_settings.btn_norm2,'Value')%no normalization
                obj.isMVC = false;
                obj.maxVal = [1,1,1];
            end
            if get(handles_settings.btn_norm1,'Value')%normalize to MVC
                obj.isMVC = true;
                obj.maxVal = [1,1,1];
                for i =1:obj.n_plots
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
            if filterFlag
                obj.filteredEMG = bp_filter(obj,obj.rawEMG);
            end
            switch featureVal
                case 1 %RMS
                    if bipolarFlag
                        obj.bipolarEMG = mono2bi(obj,obj.filteredEMG);
                        obj.processedEMG = get_rms(obj,obj.bipolarEMG);
                    else
                        obj.processedEMG = get_rms(obj, obj.filteredEMG);
                    end
                case 2 %MDF
                    if bipolarFlag
                        obj.bipolarEMG = mono2bi(obj,obj.filteredEMG);
                        obj.processedEMG = get_mdf(obj,obj.bipolarEMG);
                    else
                        obj.processedEMG = get_mdf(obj, obj.filteredEMG);
                    end
                case 3 %ARV
                    if bipolarFlag
                        obj.bipolarEMG = mono2bi(obj,obj.filteredEMG);
                        obj.processedEMG = get_arv(obj,obj.bipolarEMG);
                    else
                        obj.processedEMG = get_arv(obj, obj.filteredEMG);
                    end

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
                obj.hLayout=HDEMG_Layout(obj, obj.n_plots);
                handles_layout = guidata(obj.hLayout);
            end
            %remove unwanted entries
            switch obj.n_plots
                case 1
                    set(handles_layout.edt_mapmax(2:end),'Enable','Off')
                    set(handles_layout.txt_maxval(2:end),'Enable','Off')
                case 2
                    set(handles_layout.edt_mapmax(end),'Enable','Off')
                    set(handles_layout.txt_maxval(end),'Enable','Off')      
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
                obj.hLayout=HDEMG_Layout(obj, obj.n_plots);
                return
            end
            handles_layout = guidata(obj.hLayout);
            
            data = obj.processedEMG;
            ncols = size(obj.processedEMG,2);
            
            %update map
            index_for_map = round(index/10);
            maxval = [0,0,0,0]; xcg = [0,0,0,0]; ycg = [0,0,0,0];
            for i = 1:obj.n_plots
                axes(handles_layout.pax(i))
                %all rows - selected columns, check if MVC, otherwise normalize  
                norm_data = data(:,ncols/2*(i-1)+1:ncols/2*i)./obj.maxVal(i);
                disp(strcat('Normalization: Divide by:',num2str(obj.maxVal(i))));
                %use this to calculate normalized max of trial
                maxval(i) = round(max(norm_data,[],"all"),2);
                %use index to obtain data to plot
                mapData = data(index_for_map,ncols/2*(i-1)+1:ncols/2*i);
                [xcg(i),ycg(i)]=map_8x4(mapData);
                %calculate max
                %update text
                set(handles_layout.txt_maxval(i), 'String', num2str(maxval(i)));
            end
            %update cursor
            axes(handles_layout.axs_aux)
            hold on
            plot(obj.time(index),obj.auxData(index),'o','LineWidth',2,'MarkerSize',5,'MarkerEdgeColor','k')
            hold off
            
            % if cci is checked
            if ~isempty(obj.cci_grids)
                index_for_map = round(index/10);
                grid_cumusm = cumsum(obj.grid_config);
                for i = 1:length(obj.cci_grids)
                    grid_for_cci = grid_cumusm(obj.cci_grids(i));
                    data_cci(i,:) = data(index_for_map,(grid_for_cci-1)*ncols/2+1:grid_for_cci*ncols/2); 
                end
                cci_val = get_metrics_cci(obj,data_cci(1,:),data_cci(2,:));
                else
                cci_val = 0;
            end

            %get results
            filename = get(handles_layout.edt_filename,'String');
            contents = cellstr(get(handles_layout.popup_feature,'String'));
            featurename = contents{get(handles_layout.popup_feature,'Value')};
            results_vector = [{filename},{featurename},{obj.epochsize*1000/obj.f_samp},get_results(obj,data,index,xcg,ycg,maxval),{cci_val}];       
        end

        function y_vector = get_results(obj,data,index,xcg,ycg,maxval)
            y_vector = {};
            ncols = size(data,2);
            for i = 1:obj.n_plots
                index_for_map = round(index/10);
                datanum = data(index_for_map,ncols/2*(i-1)+1:ncols/2*i);
                diff = obj.diff_channel(i);
                result_from_metrics = get_metrics_rms(obj,datanum,diff);
                y_vector = [y_vector,strcat('grid',num2str(i),': ',num2str(size(datanum,2))),num2cell(result_from_metrics),num2cell(maxval(i)),num2cell(xcg(i)),num2cell(ycg(i))];
            end
        end

        function change_minmax(obj)
            handles_layout = guidata(obj.hLayout);
            cmin = str2double(get(handles_layout.edt_mapmin,'String'));
            cmaxs = [1,1,1];
            for i = 1:obj.n_plots
                cmaxs(i) = str2double(get(handles_layout.edt_mapmax(i),'String'));
                axes(handles_layout.pax(i))
                caxis([cmin, cmaxs(i)]);
            end
        end
    end
end
