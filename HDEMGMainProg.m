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
        EMGData;
        time;
        Data;
        auxData;
        lastIndex = 0;
        isMVC;
        useAux;
        maxVal =[1,1,1,1];
        cci_grids = [];
        GridLayoutObjs;
    end

    methods(Access = public)

        function obj = HDEMGMainProg(varargin)
            % Intitalize the Controller object and make sure, that a handle to the
            % MainFigure is passed. After passing this handle, a new
            % window (hUserWindow) will be created, that will be the
            % feedback/instruction window for the subject
            obj.hSettings = HDEMG_Settings(obj);
            obj.fileName = [];
        end
        function obj = load_defaults(obj)
            config;
            obj.f_samp = F_SAMP;
            obj.epochsize = WINDOW_SIZE_MS*obj.f_samp/1000;
        end

        function obj = create_layouts(obj)
            handles_settings = guidata(obj.hSettings);
            %get layout values
            layouts = handles_settings.layout_order-1; 
            n_layouts = length(find(layouts));    
            for i = 1:n_layouts
                obj.GridLayoutObjs{i} = CreateHDEMGLayout(i,layouts(i));
            end           
        end

        function obj = assign_data_to_layouts(obj, Data)
            n_layouts = obj.GridLayoutObjs{end}.index;
            total_cols = 0; 
            total_cols_cumsum = zeros(n_layouts,1);
            for i =1:n_layouts
                total_cols = total_cols + obj.GridLayoutObjs{i}.numcols;
                total_cols_cumsum(i) = total_cols;
            end
            if ~(size(Data,2)==total_cols)
                disp(strcat("Loadfile Warning: There are supposed to be ",num2str(total_cols), " columns"));
                Data = [];%force an error                            
            else
                disp("No warnings: Data columns match layout")
            end   
            for i =1:n_layouts
                start_col = total_cols_cumsum(i) - obj.GridLayoutObjs{i}.numcols + 1;
                end_col = total_cols_cumsum(i);            
                obj.GridLayoutObjs{i}.rawEMG = Data(:,start_col:end_col);
            end
        end

        function [Data, obj] = load_data(obj)
            % Intitalize the Controller object and make sure, that a handle to the
            % MainFigure is passed. After passing this handle, a new
            name_ext = strsplit(obj.fileName,'.');
            if strcmp(name_ext{2},'mat')
                load(obj.fileName)
                obj.Data = Data;
                if mod(size(Data,2),32)==1
                    obj.EMGData=Data(:,1:end);
                else
                    obj.EMGData=Data(:,1:end-1);
                end  
                obj.time=Time;
            elseif strcmp(name_ext{2},'csv')
                Data=csvread(obj.fileName);
                obj.Data = Data;
                if mod(size(Data,2),32)==1
                    obj.EMGData=Data(:,2:end);
                else
                    obj.EMGData=Data(:,2:end-1);
                end                
                obj.time=Data(:,1);
            end
        end

        function obj = get_entries_from_settings(obj)
            handles_settings = guidata(obj.hSettings);
            
            % get and set information from grids
            for i = 1:obj.GridLayoutObjs{end}.index
                if get(handles_settings.btn_norm3,'Value')||get(handles_settings.btn_norm2,'Value')%no normalization
                    obj.GridLayoutObjs{i}.isMVC = false;
                    obj.GridLayoutObjs{i}.maxVal = 1;
                end
                if get(handles_settings.btn_norm1,'Value')%normalize to MVC
                    obj.GridLayoutObjs{i}.isMVC = false;
                    obj.GridLayoutObjs{i}.maxVal = str2double(get(handles_settings.edt_mvcval(i),'String'));                 
                end
            end
            guidata(obj.hSettings,handles_settings); % update obj in handles_settings     

            %check cci
            if get(handles_settings.chk_cci,'Value')
                %validate cci settings
                val1 = get(handles_settings.popup_agon,'Value');
                val2 = get(handles_settings.popup_antagon,'Value');
                if isequal(val1,val2)
                    disp("WARNING: Using same grids for CCI");
                    obj = []; % force an error
                elseif ~isequal(obj.GridLayoutObjs{val1}.numcols,obj.GridLayoutObjs{val2}.numcols)
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
            for i = 1:obj.GridLayoutObjs{end}.index
                if filterFlag
                    obj.GridLayoutObjs{i}.filteredEMG = bp_filter(obj,obj.GridLayoutObjs{i}.rawEMG);
                end
                if bipolarFlag
                    obj.GridLayoutObjs{i}.bipolarEMG = obj.GridLayoutObjs{i}.bipolar_converter(obj,obj.GridLayoutObjs{i}.filteredEMG);
                else
                    obj.GridLayoutObjs{i}.bipolarEMG = obj.GridLayoutObjs{i}.filteredEMG;
                end
                switch featureVal
                    case 1 %RMS
                        obj.GridLayoutObjs{i}.processedEMG = get_rms(obj,obj.GridLayoutObjs{i}.bipolarEMG);
                    case 2 %MDF
                        obj.GridLayoutObjs{i}.processedEMG = get_mdf(obj,obj.GridLayoutObjs{i}.bipolarEMG);
                    case 3 %ARV
                        obj.GridLayoutObjs{i}.processedEMG = get_arv(obj,obj.GridLayoutObjs{i}.bipolarEMG);
                    otherwise
                        disp('invalid entry')
                end
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
                obj.hLayout=HDEMG_Analysis(obj, obj.GridLayoutObjs{end}.index);                
            end
            handles_layout = guidata(obj.hLayout);
            %remove unwanted entries
            n_layouts = obj.GridLayoutObjs{end}.index;
            set(handles_layout.txt_gridnum(n_layouts+1:end),'Visible','Off')
            set(handles_layout.edt_mapmax(n_layouts+1:end),'Visible','Off')
            set(handles_layout.txt_maxval(n_layouts+1:end),'Visible','Off')

            %update info
            set(handles_layout.edt_filename, 'String', obj.fileName);

            %set aux data
            set(handles_layout.txt_busy,'Visible', 'On');pause(0.05)            
            if get(handles_settings.chk_aux,'Value')
                obj.useAux = true;
                obj.auxData=obj.Data(:,str2double(get(handles_settings.edt_aux,'String')));
            else
                obj.useAux = false;
                obj.auxData=obj.Data(:,1);%initialize 1D array
                obj.GridLayoutObjs{1}.filteredEMG = bp_filter(obj,obj.GridLayoutObjs{1}.rawEMG);
                obj.GridLayoutObjs{1}.processedEMG = get_rms(obj, obj.GridLayoutObjs{1}.filteredEMG,1);
                obj.auxData = mean(obj.GridLayoutObjs{1}.processedEMG(:,randperm(size(obj.GridLayoutObjs{1}.processedEMG,2),10)),2); % when without aux, use EMG data
            end
            set(handles_layout.txt_busy,'Visible', 'Off');
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
                obj.hLayout=HDEMG_Analysis(obj, obj.GridLayoutObjs{end}.index);
                return
            end
            handles_layout = guidata(obj.hLayout);    
            n_layouts = obj.GridLayoutObjs{end}.index;            
            %update maps
            if obj.useAux
                index_for_map = round(index/10); 
            else
                index_for_map = round(index);
            end
            maxval = [0,0,0,0]; xcg = [0,0,0,0]; ycg = [0,0,0,0];grid_results={};
            for i = 1:n_layouts
                axes(handles_layout.pax(i))
                %all rows - selected columns normalize
                data = obj.GridLayoutObjs{i}.processedEMG; 
                norm_data = data./obj.GridLayoutObjs{i}.maxVal;
                disp(strcat('Normalization: Divide by:',num2str(obj.GridLayoutObjs{i}.maxVal)));
                %use this to calculate normalized max of trial
                maxval(i) = round(max(norm_data,[],"all"),2);
                %use index to obtain data to plot
                mapData = norm_data(index_for_map,:);
                [xcg(i),ycg(i)]=obj.GridLayoutObjs{i}.mapper(obj,mapData);
                %get results
                diff = obj.GridLayoutObjs{i}.diff_channel;
                num_results = [get_metrics_rms(obj,mapData,diff),maxval(i),xcg(i),ycg(i)];
                grid_info = strcat('Grid',num2str(i),{': '},num2str(size(mapData,2)));
                grid_results{i} = [grid_info,num2cell(num_results)];
                %update text
                set(handles_layout.txt_maxval(i), 'String', num2str(maxval(i)));
            end

            %update cursor
            axes(handles_layout.axs_aux)
            hold on
            plot(obj.time(index),obj.auxData(index),'o','LineWidth',2,'MarkerSize',5,'MarkerEdgeColor','k')
            hold off

            %get cci results
            if ~isempty(obj.cci_grids)
                for i = 1:length(obj.cci_grids)
                    data = obj.GridLayoutObjs{obj.cci_grids(i)}.processedEMG; 
                    norm_data = data./obj.GridLayoutObjs{obj.cci_grids(i)}.maxVal;
                    mapData = norm_data(index_for_map,:);
                    data_cci(i,:) = mapData;
                end
                cci_val = get_metrics_cci(obj,data_cci(1,:),data_cci(2,:));
            else
                cci_val = 0;
            end

            %create result vector
            filename = get(handles_layout.edt_filename,'String');
            contents = cellstr(get(handles_layout.popup_feature,'String'));
            featurename = contents{get(handles_layout.popup_feature,'Value')};
            metrics_all = {};
            for i = 1:n_layouts
                metrics_all = [metrics_all grid_results{i}];
            end
            results_vector = [{filename},{featurename},{index},{obj.epochsize*1000/obj.f_samp},num2cell(cci_val),metrics_all];       
        end


        function change_minmax(obj)
            handles_layout = guidata(obj.hLayout);
            cmin = str2double(get(handles_layout.edt_mapmin,'String'));
            cmaxs = [1,1,1,1];
            for i = 1:obj.GridLayoutObjs{end}.index
                cmaxs(i) = str2double(get(handles_layout.edt_mapmax(i),'String'));
                axes(handles_layout.pax(i))
                caxis([cmin, cmaxs(i)]);
            end
        end
    end
end
