classdef CreateHDEMGLayout %< SignalProcessing
    % class CreateHDEMGLayout
    %
    % Author: Ashirbad Pradhan, 2023.
    properties(GetAccess = 'public', SetAccess = 'protected', Transient = true)
        index
        layout_select
        bipolarsize
        mapper
        bipolar_converter
        data_range
        numcols
        diff_channel
    end
    properties(GetAccess = 'public', SetAccess = 'public', Transient = true)
        rawEMG
        filteredEMG
        bipolarEMG
        processedEMG
        normEMG
        isMVC
        maxVal        
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
