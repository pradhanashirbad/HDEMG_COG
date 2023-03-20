classdef CreateHDEMGLayout %< SignalProcessing
    % class CreateHDEMGLayout
    %
    % Author: Ashirbad Pradhan, 2023.
    properties(GetAccess = 'public', SetAccess = 'protected', Transient = true)
        index               % keeps track of serial number of layouts . use end to obtain the number of layouts
        layout_select       % value assigned from the drop down, 1- 32, 2- 64 Sqr, 3- 64 Long
        data_range          % The starting index (=1) and final index (=32/64) for assigning data to layouts
        numcols             % The ending index (=32/64) for storing the number of columns .... redundant
        diff_channel        % For calculation using central channel of the layout. Assigned separately for all layouts
        bipolarsize         % Monopolar to bipolar reduces the number of channels, bipolarsize stores the column numbers for bipolar data format
        mapper              % Mapping function for color maps
        bipolar_converter   % Converting function for monopolar to bipolar

    end
    properties(GetAccess = 'public', SetAccess = 'public', Transient = true)
        rawEMG              % raw EMG data
        filteredEMG         % if chk_bpfilter = true, get filtered EMG data
        bipolarEMG          % if chk_bipolar = true, convert to bipolar
        processedEMG        % get windowed processing for rms, mdf and arv feature extraction
        normEMG             % divide processedEMG by max RMS value or 1 (no-normalize)
        isMVC               % true false value for normalize or no-normalize
        maxVal              % stores max processedEMG value in each layout
    end
    methods(Access = public)
        function obj = CreateHDEMGLayout(index,layout_select)
            % Constructor
            obj.index = index;
            obj.layout_select = layout_select;
            obj = get_layoutproperties(obj);
        end
        function obj = get_layoutproperties(obj)
            switch obj.layout_select
                case 1
                    obj.numcols = 32;
                    obj.data_range = [1,32];
                    obj.bipolarsize = 28;
                    obj.bipolar_converter = @bipolar_converter_8x4;
                    obj.mapper = @mapper_8x4;
                    obj.diff_channel = 11;
                case 2
                    obj.numcols = 64;
                    obj.data_range = [1,64];
                    obj.bipolarsize = 56;
                    obj.bipolar_converter = @bipolar_converter_8x8;
                    obj.mapper = @mapper_8x8;
                    obj.diff_channel = 25;
                case 3
                    obj.numcols = 64;
                    obj.data_range = [1,65];
                    obj.bipolarsize = 60;
                    obj.bipolar_converter = @bipolar_converter_13x5;
                    obj.mapper = @mapper_13x5;
                    obj.diff_channel = 11;
                otherwise
                    disp('choose another one')
            end
        end
    end
    methods
        function obj = set.rawEMG(obj,Data)
            if obj.layout_select==3
                extra_entry = mean(Data(:,[1,13,14]),2);
                obj.rawEMG = [extra_entry Data];
            else
                obj.rawEMG = Data;
            end
        end
    end
end
