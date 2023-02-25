classdef SignalProcessing < handle
    properties(GetAccess = 'public', SetAccess = 'public', Transient = true)
        useBipolar;
        usebpfilter;
        epoch_ms;
        
    end
    methods(Access=public)
        function obj = SignalProcessing()
            obj.useBipolar = false;
            obj.usebpfilter = false;
            obj.epoch_ms = 250;
        end
        function y = bp_filter(obj,newdata)
            disp('Bandpass Fitered')
            y = bandpass_filter(obj,newdata);            
        end
        function y = mono2bi(obj,newdata)
            disp('Bipolar Differential')
            y = mono2bi32x2(obj,newdata);            
        end
        function y = get_rms(obj,newdata)
            disp('moving window RMS')
            for j = 1:size(newdata,2) %for every channel
                y(:,j) = rms(obj,newdata(:,j),obj.epoch_ms,obj.epoch_ms-1,1); %  RMS using an epoch length of 'epoch_ms' ms
            end            
        end
        function y = get_mdf(obj,newdata)
            disp('moving window Median Frequency (MDF)')
            for j = 1:size(newdata,2) %for every channel
                y(:,j) = mdf(obj,newdata(:,j),obj.epoch_ms,obj.epoch_ms-1,1); %  MDF using an epoch length of 'epoch_ms' ms
            end            
        end
        function y = get_arv(obj,newdata)
            disp('moving window Absolute Rectified Value (ARV)')
            for j = 1:size(newdata,2) %for every channel
                y(:,j) = arv(obj,newdata(:,j),obj.epoch_ms,obj.epoch_ms-1,1); %  MDF using an epoch length of 'epoch_ms' ms
            end            
        end
        function y = get_metrics_monopolarEMG(obj,newdata)
            disp('calculating metrics from EMG data')
            diff_ch = 0;
            rmsdata = get_rms(obj,newdata);
            y = get_metrics(obj,rmsdata,diff_ch);            
        end
        function y = get_metrics_rms(obj,rmsdata,diff_ch)
            disp('calculating metrics')
            y = get_metrics(obj,rmsdata,diff_ch);            
        end
    end
end