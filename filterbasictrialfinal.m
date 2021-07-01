
%this code reads the datas collected by the n emg channels and
%does the basic filtering and frequency analsis. By default the 0th channel
%is reserved for the torque data from the cybex. the code starts reading
%from the 1st channel to the nth channel. The result figures for first
%channel are figure 1 and figure 11, the result figures for second
%channel are figure 2 and figure 12, and so on.. till nth channels.
%MNF=Mean frequency
%MDF=Median frequency



clear all
close all
clc
%change the file name in "csvread"
%make sure the file is added to the default directory

data=csvread('PYF01_contraction 4.csv');
n=1 %no. of channels of EMG
fs=1000;%sampling frequency

N=length(data(:,2));
fax_bins=[0:N-1];

% plot the raw emg data
for j=1:n;
    figure(j)
    subplot(4,1,1)
    plot(data(:,j+1),'r')
    title('raw emg')
    xlabel('samples')
    ylabel('magnitude')
end


% removing DC components
for j=1:n;
data(:,j)=data(:,j)-mean(data(:,j));

end

%defining the x-coordinates
bin_vals=[0:N-1];
fax_hz=bin_vals*fs/N;
N_2=ceil(N/2);

%n order filter using butterworth design 20-400Hz

[b a] = butter(10,[0.04 0.8],'bandpass');


% plot the filtered signal
for j=1:n
    figure(j)
    subplot(4,1,2)
    x_filtered(:,j+1)=filter(b,a,data(:,j+1));
    plot((filter(b,a,x_filtered(:,j+1))),'r')
    title('filtered signal-using butterworth filter')
    xlabel('samples')
    ylabel('Amplitude')
end


%plot rectified signal
for j=1:n;
    figure(j)
    subplot(4,1,3)
    x_rectified(:,j+1)=abs(x_filtered(:,j+1));
    plot(x_rectified(:,j+1),'r');
    title('fullwave rectification')
    xlabel('samples')
    ylabel('Amplitude')

end


%low pass filter of 15Hz
[b1 a1]=butter(4,0.030,'low')

for j=1:n
    figure(j)
    subplot(4,1,4)
    plot(filtfilt(b1,a1,x_rectified(:,j+1)),'r')
    title('filtered signal-using butterworth filter')
    xlabel('samples')
    ylabel('Amplitude')

end



%now we use filtered signal for frequency analysis
%plot of magnitude spectrum
x_mags=abs(fft(x_filtered));
for j=1:n
    figure(10+j)
    subplot(2,2,1)
    plot(fax_hz(1:N_2),x_mags(1:N_2,j+1),'r')
    xlabel('Frequency(Hz)');
    ylabel('Magnitude');
    title('Magnitude Spectrum in Hz');
    axis tight
end



%plot for power spectrum
psdx = (x_mags.^2);
for j=1:n
    figure(10+j)
    subplot(2,2,2)
    plot(fax_hz(1:N_2),psdx(1:N_2,j+1),'r')
    xlabel('Frequency(Hz)');
    ylabel('Power');
    title('Power Spectrum in Hz');
    axis tight
end

%%DFT power spectrum in decibels
for j=1:n
    figure(10+j)
    subplot(2,2,3)
    plot(fax_hz(1:N_2),20*log10(x_mags(1:N_2,j+1)),'r')
    xlabel('Frequency(Hz)');
    ylabel('Power(db)');
    title('Power Spectrum in decibels');
    axis tight
    
end

%calculate mean and median
psdx=psdx'
for j=1:n
    mnfx(:,j+1) = sum(fax_hz(1:N_2).*psdx(j+1,1:N_2))/sum(psdx(j+1,1:N_2))
end

err = zeros(N_2,n+1);
index = zeros(1,n+1);
min = realmax('double');
for j=1:n
for i = 1:N_2-1
    err(j+1,i) = abs(sum(psdx(j+1,1:i)) - sum(psdx(j+1,i+1:N_2)));
    if err(j+1,i)<min
        min = err(j+1,i);
        index(j+1) = i*fs/N;
    end
    
end
min = realmax('double');
end
index


t=0:0.001:5.024;                                                % Time Vector
s = data(:,30);                                                % Signal Vector
Fs = 1/mean(diff(t));                                   % Sampling Frequency
Fn = Fs/2;                                              % Nyquist Frequency
L = length(t);
FTs = fft(s)/L;
Fv = linspace(0, 1, fix(L/2)+1)*Fn;                     % Frequency Vector
Iv = 1:length(Fv);                                      % Index Vector
CumAmp = cumtrapz(Fv, abs(FTs(Iv)));                    % Integrate FFT Amplitude
MedFreq = interp1(CumAmp, Fv, CumAmp(end)/2);           % Use ‘interp1’ To Find ‘MF’
figure(1)
plot(Fv, abs(FTs(Iv))*2, '-b')                          % Plot FFT
hold on
% plot(Fv, CumAmp, '-g')                                  % Plot Cumulative Amplitude Integral
plot([MedFreq MedFreq], ylim, '-r', 'LineWidth',1)      % Plot Median Frequency
hold off
grid

%printing the values of MNF and MDF
for j=1:n
    figure(10+j)
    subplot(2,2,4)
    text(0.45,0.55,['MNF = ',num2str(mnfx(j+1))])
    text(0.45,0.45,['MDF = ',num2str(index(j+1))])
end
    
    
disp(['MNF=' num2str(mnfx)])
disp(['MDF=' num2str(index)])