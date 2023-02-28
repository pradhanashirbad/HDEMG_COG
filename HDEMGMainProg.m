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
        normFlag;
        lastIndex = 0;
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
            obj.f_samp = F_SAMP;
            obj.epochsize = WINDOW_SIZE_MS*obj.f_samp/1000;
        end

        function [Data, obj] = loaddata(obj)
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
            guidata(obj.hSettings,handles_settings);
        end

        function [filterFlag,bipolarFlag,normFlag,featureVal] =  get_processing_settings(obj)
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
            if get(handles_settings.btn_norm3,'Value')||get(handles.btn_norm2,'Value')%no normalization
                normFlag = false;
            end
            if get(handles_settings.btn_norm1,'Value')%normalize to MVC
                normFlag = true;
            end
        end


        function obj = sigpro(obj, filterFlag, bipolarFlag, normFlag, featureVal)

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

            if ~normFlag%no normalization
                obj.normEMG=obj.processedEMG;
            else
                obj.normEMG=obj.processedEMG./maxval; %normalize to MVC
            end
        end


        function obj = loadlayout(obj)
            if isempty(obj.hSettings)
                obj.hSettings=HDEMG_Settings(obj);
                disp('Error: Restart program')
                return
            end
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

            % load layout
            if isempty(obj.hLayout)
                obj.hLayout=HDEMG_Layout(obj, obj.n_plots);
                handles_layout = guidata(obj.hLayout);
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
                obj.auxData = mean(obj.processedEMG(:,randperm(size(obj.processedEMG,2),6)),2); % when without aux, use EMG data
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

        function [results_vector,obj] = updatelayout(obj,index)
            if isempty(index)
                index = round(length(obj.time)/2);
            end
            maxval = round(max(obj.normEMG,[],"all"),2);
            obj.lastIndex = index;
            if isempty(obj.hLayout)
                obj.hLayout=HDEMG_Layout(obj, obj.n_plots);
                return
            end
            handles_layout = guidata(obj.hLayout);
            set(handles_layout.txt_maxval, 'String', num2str(maxval));
            data = obj.normEMG;
            ncols = size(obj.normEMG,2);

            %update map
            index_for_map = round(index/10);
            for i = 1:obj.n_plots
                axes(handles_layout.pax(i))
                [xcg(i),ycg(i)]=map_8x4(data(index_for_map,ncols/2*(i-1)+1:ncols/2*i));
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
            results_vector = [{filename},{featurename},{obj.epochsize*1000/obj.f_samp},get_results(obj,data,index,xcg,ycg)];
        end

        function y_vector = get_results(obj,data,index,xcg,ycg)
            y_vector = {};
            ncols = size(data,2);
            for i = 1:obj.n_plots
                index_for_map = round(index/10);
                datanum = data(index_for_map,ncols/2*(i-1)+1:ncols/2*i);
                diff = obj.diff_channel(i);
                result_from_metrics = get_metrics_rms(obj,datanum,diff);
                y_vector = [y_vector,strcat('grid',num2str(i)),num2cell(result_from_metrics),num2cell(xcg(i)),num2cell(ycg(i))];
            end
            %add pointer to x plot
        end

        function obj = change_feature(obj,feature)
            switch feature
                case 1 %32 x 2
                    obj.n_plots = 2;
                case 2
                    disp('zero')
                otherwise
                    disp('choose another one')
            end
        end
        %add pointer to x plot

    end
end



%      function IMUCalibrate(obj, hObj, varargin)
%          obj.controlObject.updateCalibrationData();
%      end