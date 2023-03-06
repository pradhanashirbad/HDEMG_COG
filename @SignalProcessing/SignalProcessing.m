classdef SignalProcessing < handle
    properties(GetAccess = 'public', SetAccess = 'public', Transient = true)
        epochsize;
        f_samp;

    end
    methods(Access=public)
        function obj = SignalProcessing()
            config;
            obj.f_samp = F_SAMP;
            obj.epochsize = WINDOW_SIZE_MS*obj.f_samp/1000;
        end
        function y = bp_filter(obj,newdata)
            disp('Bandpass Fitered')
            y = bandpass_filter(obj,newdata,obj.f_samp);
        end
        function y = get_rms(obj,newdata,stride)
            if nargin==2
                stride = 10;
            end
            disp(strcat('calculating: moving window RMS Epoch (samples):', num2str(obj.epochsize)))
            for j = 1:size(newdata,2) %for every channel
                y(:,j) = rms(obj,newdata(:,j),obj.epochsize,obj.epochsize-stride,1); %  RMS using an epoch length of 'epoch_ms' ms
            end
        end
        function y = get_mdf(obj,newdata)
            disp(strcat('calculating: moving window MDF Epoch (samples):', num2str(obj.epochsize)))
            for j = 1:size(newdata,2) %for every channel
                y(:,j) = mdf(obj,newdata(:,j),obj.epochsize,obj.epochsize-10,1,obj.f_samp); %  MDF using an epoch length of 'epoch_ms' ms
            end
        end
        function y = get_arv(obj,newdata)
            disp(strcat('calculating: moving window ARV Epoch (samples):', num2str(obj.epochsize)))
            for j = 1:size(newdata,2) %for every channel
                y(:,j) = arv(obj,newdata(:,j),obj.epochsize,obj.epochsize-10,1); %  MDF using an epoch length of 'epoch_ms' ms
            end
        end
        function y = get_metrics_monopolarEMG(obj,newdata)
            disp(strcat('calculating metrics monopolar Epoch(samples):', num2str(obj.epochsize)))
            diff_ch = 0;
            rmsdata = get_rms(obj,newdata);
            y = get_metrics(obj,rmsdata,diff_ch);
        end
        function y = get_metrics_rms(obj,rmsdata,diff_ch)
            disp(strcat('calculating: metrics Epoch(samples):', num2str(obj.epochsize)))
            y = get_metrics(obj,rmsdata,diff_ch);
        end
        function y = get_metrics_cci(obj,rmsdata1,rmsdata2)
            disp(strcat('calculating: cci Epoch(samples):', num2str(obj.epochsize)))
            if isequal(length(rmsdata1),length(rmsdata2))
                y = get_cci(obj,rmsdata1,rmsdata2);
            else
                y=[];
                disp("Error in calculating CCI, grids are unequal length")
            end
        end
    end
    methods(Access=public)
        function y = bipolar_converter_8x4(obj,newdata)
            y = mono2bi32(obj,newdata);
        end
        function y = bipolar_converter_8x8(obj,newdata)
            y = mono2bi32x2(obj,newdata);
        end
        function y = bipolar_converter_13x5(obj,newdata)
            y = mono2bi65(obj,newdata);
        end
    end
    methods (Access=public)
        function [y1,y2] = mapper_8x4(obj,newdata)
            [y1,y2] = map_8x4(obj,newdata);
        end
        function [y1,y2] = mapper_8x8(obj,newdata)
            [y1,y2] = map_8x8(obj,newdata);
        end
        function [y1,y2] = mapper_13x5(obj,newdata)
            [y1,y2] = map_13x5(obj,newdata);
        end        
    end
end