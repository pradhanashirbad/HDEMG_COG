function result_vector = get_metrics(obj,Data_rms,diff_ch)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
                
ncols = size(Data_rms,2);

%entropy Calculation
% entropy=zeros(n,1);
rms_sq=Data_rms.^2;
sum_rms_sq=sum(rms_sq);
probability=rms_sq./sum_rms_sq;
entropy=-1*sum(probability.*log2(probability));

%CoV calculation
means=mean(Data_rms);       % Calculate mean RMS 
std_dev=std(Data_rms);       % Calculated S.D
cov=std_dev./means; 
cov_percentage=cov*100;

%Build the feature 'diff' 
if ~(diff_ch==0)
diff_intensity = log10(Data_rms(:,diff_ch));
else
diff_intensity = nan;
end

%Build the feature 'Intensity'
intensity = log10((1/ncols)*sum(Data_rms)); %calculate the Intensity

result_vector = [entropy,cov_percentage,intensity,diff_intensity,means];
%plot(currentData);
end