function varargout = FrequencyAnalysis(varargin)
% FREQUENCYANALYSIS MATLAB code for FrequencyAnalysis.fig
%      FREQUENCYANALYSIS, by itself, creates a new FREQUENCYANALYSIS or raises the existing
%      singleton*.
%
%      H = FREQUENCYANALYSIS returns the handle to a new FREQUENCYANALYSIS or the handle to
%      the existing singleton*.
%
%      FREQUENCYANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FREQUENCYANALYSIS.M with the given input arguments.
%
%      FREQUENCYANALYSIS('Property','Value',...) creates a new FREQUENCYANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FrequencyAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FrequencyAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FrequencyAnalysis

% Last Modified by GUIDE v2.5 03-Dec-2020 18:32:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FrequencyAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @FrequencyAnalysis_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before FrequencyAnalysis is made visible.
function FrequencyAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FrequencyAnalysis (see VARARGIN)


% Choose default command line output for FrequencyAnalysis
handles.output = hObject;
handles.timeinput=0;
handles.part=000;
handles.fileName = ('PYF01_contraction 4.csv');%
handles.gender = 11;%
handles.age = 1;%
handles.outfilename= ('MainReport.csv'); %
handles.channel=15;
handles.entropy=0;
handles.cov_percentage=0;
handles.Intensity=0;
handles.diff=0;
handles.mean_RMS=0;
handles.instantmax=0;
handles.x_mags=[];
handles.freqstate=0;
handles.normstate=0;
handles.ms250state=1;
handles.ms500state=0;
handles.ms1000state=0;
handles.normstate_mvc=0;
handles.normstate_off=1;
handles.epoch_ms=1000;
handles.medfreq=0;
handles.f=[];
handles.mdfmapstate=0;
handles.plotsize=0;
handles.Data_rms=[];
handles.mdfmin=0;
handles.mdfmax=100;
handles.xcg=0;
handles.ycg=0;
handles.values=[];
handles.aux_value=1;
% axes(handles.map_figure)
% %plot(raw_signal, x,y, 'r.')
% plot(handles.currentData)
set(handles.slider1, 'min', 0);
set(handles.slider1, 'max', 3000);
set(handles.slider1, 'Value', 1500);
handles.mvcinput=1;
set(handles.slider_max, 'Value', 0.6);
handles.min=0;
handles.max=0;
handles.max_norm=1;
handles.raw=zeros(60000,64);
handles.currentData=zeros(60000,59);
handles.time=zeros(50000,1);
handles.aux=zeros(60000,1);
handles.startpoint=1000;
handles.endpoint=2000;
childlist=allchild(handles.buttongroup_norm);
for i=1:length(childlist)
    set(childlist(i),'Enable','off')
end
childlist2=allchild(handles.uipanel1);
for i=1:length(childlist)
    set(childlist2(i),'Enable','off')
end
set(handles.loadfile,'Enable','off')
set(handles.filter_button,'Enable','off')
% axes(handles.mdf_plot);
% rmsfreq(handles.currentData(:,handles.channel),100,0,0);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FrequencyAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FrequencyAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Data=handles.currentData;
guidata(hObject, handles);
position=get(handles.slider1,'Value');

n=size(Data,1);
% Time=1:n;
% Time=Time';

%x_mid = ceil(position*10000)
x_mid = ceil(position);
set(handles.time_ms,'String',num2str(x_mid));
% set(handles.time_ms,'String',num2str(x_mid));
if handles.ms250state==1
    Data_2s = Data(x_mid-124:x_mid+125,:);
    Data_aux=handles.aux(x_mid-124:x_mid+125,:);
elseif handles.ms500state==1
    Data_2s = Data(x_mid-249:x_mid+250,:);
    Data_aux=handles.aux(x_mid-249:x_mid+250,:);
else
    Data_2s = Data(x_mid-499:x_mid+500,:);
    Data_aux=handles.aux(x_mid-500:x_mid+500,:);
end
% Time_2s = Time(x_mid-499:x_mid+500,:);
if handles.freqstate==1
handles.x_mags=abs(fft(Data_2s));
end
ch1_diff = 11;
ch1_diff = 12;

handles.epoch_ms = size(Data_2s,1);
%Data_rms=zeros(handles.epoch_ms,64);
handles.aux_value = mean(Data_aux);
% Processing
Data_diff = Data_2s(:,ch1_diff);
for j = 1:59 %for every channel
    Data_rms(:,j) = rms(Data_2s(:,j),handles.epoch_ms,0,0); %  RMS using an epoch length of 'epoch_ms' ms
    %Data_rms is a vector in which each column corresponds to the rms
    %vector of each channel     
    Data_diff_rms = rms(Data_diff,handles.epoch_ms,0,0); 
    %Data_diff_rms is the RMS of the difference computade with ch1_diff and
    %ch2_diff
%     Data_mdf(:,j) = mdf(Data_2s(:,j),handles.epoch_ms,0,0);
    
end

if handles.freqstate==1
    axes(handles.fftplot);
% %     handles.medfreq=update_fft(handles.x_mags(:,handles.channel),handles.epoch_ms,0,0,handles.freqstate,...
% %         handles.channel);
    set(handles.fftplot,'XLim',[0 500]);
    set(handles.fftplot,'YLim',[0 0.3]);
% %     set(handles.med_freq_disp,'String',num2str(handles.medfreq));
    
    axes(handles.mdfplot_figure);
% %     for j = 1:59 %for every channel
% %         Data_mdf(:,j) = mdf(Data_2s(:,j),handles.epoch_ms,0,0);
% %     end
    handles.Data_mdf=Data_mdf;
    mdfmap_plot(handles.Data_mdf,handles.mdfmin,handles.mdfmax);
end

max_rms = max(Data_rms);
handles.instantmax=max_rms;
set(handles.disp_max,'String',num2str(max_rms));
% % disp(strcat(num2str(round(max_rms,3)),'  ','mV'))
set(handles.maxval_mv,'String', strcat(num2str(round(max_rms,3)),{' '},'mV'));
Data_rms=Data_rms/max_rms;
max90=str2double(get(handles.max_num,'String'));
Data_rms(Data_rms<max90)=0;
% handles.medfreq=mean(Data_mdf);
% set(handles.med_freq_disp,'String',num2str(handles.medfreq));
%entropy Calculation
% entropy=zeros(n,1);
rms_sq=Data_rms.^2;
sum_rms_sq=sum(rms_sq);
probability=rms_sq./sum_rms_sq;
handles.entropy=-1*sum(probability.*log2(probability));

%CoV calculation
means=mean(Data_rms);       % Calculate mean RMS 
std_dev=std(Data_rms);       % Calculated S.D
cov=std_dev./means; 
handles.cov_percentage=cov*100;

%mean RMS
handles.mean_RMS=means;

%Build the feature 'diff' 
handles.diff = log10(Data_diff_rms);

%Build the feature 'Intensity'
handles.Intensity = log10( (1/59)*sum(Data_rms)); %calculate the Intensity
%plot(handles.currentData);

%map figure
axes(handles.map_figure)
handles.Data_rms=Data_rms;
if handles.normstate==1
    handles.max=1;
    handles.min=0;
elseif handles.normstate_mvc==1
    handles.max=1;
    handles.min=0;
end
[handles.xcg,handles.ycg]=map_print(handles.Data_rms,handles.min,handles.max);

hObject.UserData=[handles.part handles.age handles.gender handles.entropy ...
    handles.cov_percentage handles.Intensity handles.diff handles.xcg ...
    handles.ycg handles.mean_RMS handles.aux_value];

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in export_button.
function export_button_Callback(hObject, eventdata, handles)
% hObject    handle to export_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);
slider1_Callback(hObject, eventdata, handles);
%h=findobj('Tag','slider1');
set(handles.participant_text,'String',num2str(handles.part));
participant_text_Callback(hObject, eventdata, handles)
values=hObject.UserData
% handles.values=[handles.part handles.age handles.gender handles.entropy ...
%     handles.cov_percentage handles.Intensity handles.diff handles.xcg ...
%     handles.ycg handles.mean_RMS]
dlmwrite(handles.outfilename,[values],'-append')
guidata(hObject, handles);


function participant_text_Callback(hObject, eventdata, handles)
% hObject    handle to participant_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of participant_text as text
%        str2double(get(hObject,'String')) returns contents of participant_text as a double
handles.part = str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function participant_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to participant_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in age_popup.
function age_popup_Callback(hObject, eventdata, handles)
% hObject    handle to age_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns age_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from age_popup
handles.age = get(hObject,'Value');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function age_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to age_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in gender_popup.
function gender_popup_Callback(hObject, eventdata, handles)
% hObject    handle to gender_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns gender_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from gender_popup
%handles.gender = get(hObject,'String')
handles.gender = get(hObject,'Value')+10;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function gender_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gender_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function raw_signal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to raw_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate raw_signal



function min_num_Callback(hObject, eventdata, handles)
% hObject    handle to min_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_num as text
%        str2double(get(hObject,'String')) returns contents of min_num as a double
axes(handles.map_figure)
handles.min=str2num(get(hObject,'String'));
slider1_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function min_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max_num_Callback(hObject, eventdata, handles)
% hObject    handle to max_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_num as text
%        str2double(get(hObject,'String')) returns contents of max_num as a double
axes(handles.map_figure)
handles.max=str2num(get(hObject,'String'));
slider1_Callback(hObject, eventdata, handles)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function max_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadfile.
function loadfile_Callback(hObject, eventdata, handles)
% hObject    handle to loadfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.raw_signal);
handles.fileName=uigetfile({'*.*'},...
                          'File Selector');
C = strsplit(handles.fileName,'.');
tf = strcmp( C{2},'mat')
if tf == 1
    load(handles.fileName)
    handles.raw=Data;
    handles.currentData=Data;
    handles.currentData=mono2bi(handles.currentData);
else
    handles.raw=csvread(handles.fileName);
    handles.currentData=handles.raw;
    handles.currentData=mono2bi(handles.currentData);
end
update_single(handles.currentData,handles.channel,handles.time);
handles.plotsize=get(handles.raw_signal,'XLim');
set(handles.slider1, 'min', handles.plotsize(1));
set(handles.slider1, 'max', handles.plotsize(2)/10000);
set(handles.mdf_plot, 'XLim',[handles.plotsize(1) handles.plotsize(2)]);
Data2=handles.currentData(ceil(end/2)-499:ceil(end/2)+500,:);
for j = 1:59 %for every channel
    Data_rms(:,j) = rms(Data2,1000,0,0); %  RMS using an epoch length of 'epoch_ms' ms
end
max_rms = max(Data_rms);
handles.instantmax=max_rms;
disp(handles.instantmax)
set(handles.disp_max,'String',num2str(max_rms));
% % set(handles.max_num,'String',num2str(max_rms+0.8*max_rms))
handles.max=max_rms+0.8*max_rms;
set(handles.mvc_value,'String',num2str(max_rms));
slider1_Callback(hObject, eventdata, handles);
% frequencybutton_Callback(hObject, eventdata, handles);


if handles.freqstate==1
    axes(handles.fftplot);
%     handles.medfreq=update_fft(handles.x_mags(:,handles.channel),handles.epoch_ms,0,0,handles.freqstate,...
%         handles.channel);
    set(handles.fftplot,'XLim',[0 500]);
    set(handles.fftplot,'YLim',[0 0.3]);
%     set(handles.med_freq_disp,'String',num2str(handles.medfreq));
    
    axes(handles.mdf_plot);
    rmsfreq(handles.currentData(:,handles.channel),100,0,0);
    set(handles.mdf_plot, 'XLim',[handles.plotsize(1) handles.plotsize(2)])
end

guidata(hObject, handles);

function chan_num_Callback(hObject, eventdata, handles)
% hObject    handle to chan_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of chan_num as text
%        str2double(get(hObject,'String')) returns contents of chan_num as a double
axes(handles.raw_signal);
handles.channel=str2double(get(hObject,'String'));
update_single(handles.currentData,handles.channel,handles.time);
if handles.freqstate == 1
axes(handles.mdf_plot);
rmsfreq(handles.currentData(:,handles.channel),100,0,0);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function chan_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chan_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in filter_button.
function filter_button_Callback(hObject, eventdata, handles)
% hObject    handle to filter_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y=bandpass_filter(handles.raw);
handles.currentData=mono2bi(y);
handles.currentData=detrend(handles.currentData);
axes(handles.raw_signal);
update_single(handles.currentData,handles.channel,handles.time);
if handles.freqstate==1
axes(handles.fftplot)
end
slider1_Callback(hObject, eventdata, handles);
if handles.freqstate==1
axes(handles.mdf_plot);
rmsfreq(handles.currentData(:,handles.channel),100,0,0);    
end


% update_fft(handles.x_mags(:,handles.channel),handles.epoch_ms,0,0,handles.freqstate,...
%     handles.channel);
% set(handles.fftplot,'XLim',[0 500]);
% set(handles.fftplot,'YLim',[0 0.3]);
guidata(hObject, handles);


% --- Executes on button press in frequencybutton.
function frequencybutton_Callback(hObject, eventdata, handles)
% hObject    handle to frequencybutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of frequencybutton
handles.freqstate=get(hObject,'Value');
slider1_Callback(hObject, eventdata, handles);
if handles.freqstate == 1
axes(handles.mdf_plot);
rmsfreq(handles.currentData(:,handles.channel),100,0,0);
end

guidata(hObject, handles);



function min_mdf_Callback(hObject, eventdata, handles)
% hObject    handle to min_mdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_mdf as text
%        str2double(get(hObject,'String')) returns contents of min_mdf as a double
axes(handles.mdfplot_figure)
handles.mdfmin=str2num(get(hObject,'String'));
slider1_Callback(hObject, eventdata, handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function min_mdf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_mdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max_mdf_Callback(hObject, eventdata, handles)
% hObject    handle to max_mdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_mdf as text
%        str2double(get(hObject,'String')) returns contents of max_mdf as a double
axes(handles.mdfplot_figure)
handles.mdfmax=str2num(get(hObject,'String'));
slider1_Callback(hObject, eventdata, handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function max_mdf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_mdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uitoggletool4_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.xcord=ginput(1)*1000;
set(handles.slider1, 'Value', handles.xcord(1));
slider1_Callback(hObject, eventdata, handles);
guidata(hObject, handles);


% --- Executes on button press in pushbutton_normalize.
function pushbutton_normalize_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_normalize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
handles.normstate=get(hObject,'Value');
Data=handles.currentData;
for j = 1:59 %for every channel
    Data_rms_all(:,j) = rms(Data(:,j),handles.epoch_ms,100,0); %  RMS using an epoch length of 'epoch_ms' ms
end
handles.max_norm=max(max(Data_rms_all));
slider1_Callback(hObject, eventdata, handles);
set(handles.mvc_value,'String',num2str(handles.max_norm));
slider1_Callback(hObject, eventdata, handles);
guidata(hObject, handles);
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in switch_250.
function switch_250_Callback(hObject, eventdata, handles)
% hObject    handle to switch_250 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ms250state=get(hObject,'Value');
slider1_Callback(hObject, eventdata, handles);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of switch_250


% --- Executes on button press in switch_500.
function switch_500_Callback(hObject, eventdata, handles)
% hObject    handle to switch_500 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ms500state=get(hObject,'Value');
slider1_Callback(hObject, eventdata, handles);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of switch_500


% --- Executes on button press in switch_1000.
function switch_1000_Callback(hObject, eventdata, handles)
% hObject    handle to switch_1000 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ms1000state=get(hObject,'Value');
slider1_Callback(hObject, eventdata, handles);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of switch_1000


% --- Executes when selected object is changed in epoch_window.
function epoch_window_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in epoch_window 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch (get(eventdata.NewValue,'Tag'))
    case 'switch_250'
        handles.ms250state=1;
        handles.ms500state=0;
        handles.ms1000state=0;
        slider1_Callback(hObject, eventdata, handles)
    case 'switch_500'
        handles.ms250state=0;
        handles.ms500state=1;
        handles.ms1000state=0;
        slider1_Callback(hObject, eventdata, handles);
    case 'switch_1000'
        handles.ms250state=0;
        handles.ms500state=0;
        handles.ms1000state=1;
        slider1_Callback(hObject, eventdata, handles);
end
guidata(hObject, handles);


% --- Executes on button press in auxbutton.
function auxbutton_Callback(hObject, eventdata, handles)
% hObject    handle to auxbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of auxbutton


% --- Executes on button press in loadfile_aux.
function loadfile_aux_Callback(hObject, eventdata, handles)
% hObject    handle to loadfile_aux (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.slider1, 'min', 0);
set(handles.slider1, 'max', 3000);
set(handles.slider1, 'Value', 1500);
try
    addpath(fullfile(pwd,'data'))
catch
    disp('create data folder in the main folder')
end
axes(handles.raw_signal);
handles.fileName=uigetfile({'*.*'},...
                          'File Selector');
C = strsplit(handles.fileName,'.');
tf = strcmp( C{2},'mat');
if tf == 1
    load(handles.fileName)
    handles.raw=Data(:,1:64);
    handles.currentData=handles.raw;
    handles.currentData=mono2bi(handles.currentData);
    handles.time=Time;
    handles.aux=Data(:,65);
else
    Data=csvread(handles.fileName);
    handles.raw=Data(:,2:65);
    handles.currentData=handles.raw;
    handles.currentData=mono2bi(handles.currentData);
    handles.time=Data(:,1);
    handles.aux=Data(:,66);
end
update_single(handles.currentData,handles.channel,handles.time);
handles.plotsize=get(handles.raw_signal,'XLim');
set(handles.slider1, 'min', handles.plotsize(1));
set(handles.slider1, 'max', handles.plotsize(2)*1000);
%set(handles.mdf_plot, 'XLim',[handles.plotsize(1) handles.plotsize(2)]);
Data2=handles.currentData(ceil(end/2)-249:ceil(end/2)+250,:);

for j = 1:59 %for every channel
    Data_rms(:,j) = rms(Data2,handles.epoch_ms,0,0); %  RMS using an epoch length of 'epoch_ms' ms
end
max_rms = max(Data_rms);
handles.instantmax=max_rms;
set(handles.disp_max,'String',num2str(max_rms));
% % set(handles.max_num,'String',num2str(max_rms+0.8*max_rms))
handles.max=max_rms+0.8*max_rms;
axes(handles.aux_plot)
plot(handles.time,handles.aux)
set(handles.aux_plot, 'XLim',[handles.plotsize(1) handles.plotsize(2)])
slider1_Callback(hObject, eventdata, handles);
filter_button_Callback(hObject, eventdata, handles);

Data_all= detrend(handles.currentData);
Data_rms2(:,1) = rms(Data_all(:,30),200,199,1); 
max_rms = max(Data_rms2);
handles.currentData(Data_rms2<0.08*max_rms,:)=0;
% handles.currentData(Data_rms2<0.08*max_rms,59)=0.08;
set(handles.edit_start,'String',num2str(100));
set(handles.edit_end,'String',num2str(size(handles.currentData,1)-200));
guidata(hObject, handles);
% frequencybutton_Callback(hObject, eventdata, handles);



function time_ms_Callback(hObject, eventdata, handles)
% hObject    handle to time_ms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time_ms as text
%        str2double(get(hObject,'String')) returns contents of time_ms as a double
axes(handles.raw_signal)
handles.timeinput=str2num(get(hObject,'String'));
set(handles.slider1, 'Value', handles.timeinput);
slider1_Callback(hObject, eventdata, handles)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function time_ms_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_ms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in mvc_norm.
function mvc_norm_Callback(hObject, eventdata, handles)
% hObject    handle to mvc_norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.normstate_mvc=(get(hObject,'Value'));
axes(handles.map_figure)
handles.max_norm=handles.mvcinput;
%set(handles.max_num,'String',num2str(handles.instantmax+0.8*handles.instantmax));
slider1_Callback(hObject, eventdata, handles);   
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function mvc_norm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mvc_norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function mvc_value_Callback(hObject, eventdata, handles)
% hObject    handle to mvc_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mvc_value as text
%        str2double(get(hObject,'String')) returns contents of mvc_value as a double
handles.mvcinput=str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function mvc_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mvc_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in off_button.
function off_button_Callback(hObject, eventdata, handles)
% hObject    handle to off_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.normstate_off=get(hObject,'Value');
axes(handles.map_figure)
handles.max_norm=1;
set(handles.max_num,'String',num2str(handles.instantmax+0.8*handles.instantmax));
slider1_Callback(hObject, eventdata, handles);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of switch_250

% Hint: get(hObject,'Value') returns toggle state of off_button


% --- Executes when selected object is changed in buttongroup_norm.
function buttongroup_norm_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in buttongroup_norm 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch (get(eventdata.NewValue,'Tag'))
    case 'off_button'
        handles.normstate=0;
        handles.normstate_mvc=0;
        handles.normstate_off=1;
        slider1_Callback(hObject, eventdata, handles)
    case 'pushbutton_normalize'
        handles.normstate=1;
        handles.normstate_mvc=0;
        handles.normstate_off=0;
        slider1_Callback(hObject, eventdata, handles);
    case 'mvc_norm'
        handles.normstate=0;
        handles.normstate_mvc=1;
        handles.normstate_off=0;
        slider1_Callback(hObject, eventdata, handles);
end
guidata(hObject, handles);



function edit_start_Callback(hObject, eventdata, handles)
% hObject    handle to edit_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_start as text
%        str2double(get(hObject,'String')) returns contents of edit_start as a double
handles.startpoint=str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_end_Callback(hObject, eventdata, handles)
% hObject    handle to edit_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_end as text
%        str2double(get(hObject,'String')) returns contents of edit_end as a double
handles.endpoint=str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_COPexport.
function button_COPexport_Callback(hObject, eventdata, handles)
% hObject    handle to button_COPexport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.startpoint=str2double(get(handles.edit_start,'String'));
handles.endpoint=str2double(get(handles.edit_end,'String'));
Data=handles.currentData;
% Data= detrend(Data);
Data_COP = Data(handles.startpoint:handles.endpoint,:);
for j = 1:59 %for every channel
    Data_rms(:,j) = rms(Data_COP(:,j),125,90,0); 
end
max_rms = max(Data_rms,[],2);
% % Data_rms=Data_rms./max_rms;
max90=str2double(get(handles.max_num,'String'));
for i=1:size(Data_rms,1)
    Data_epoch=Data_rms(i,:);
    max_epoch = max(Data_epoch);
    Data_epoch=Data_epoch/max_rms(i);
    Data_epoch(Data_epoch<max90)=0;
    [xcg,ycg]=map_print_cog(Data_epoch,handles.min,handles.max);
    COGx(i)=xcg;
    COGy(i)=ycg; 
%     disp(strcat('running',"  ",num2str(i/size(Data_rms,1)),"%"));
% % disp(i/size(Data_rms,1));
end
axes(handles.aux_plot)
plot(1:length(COGx),COGx,'linewidth',2);
hold on
plot(1:length(COGy),COGy,'linewidth',2)
hold off
xlim([0 length(COGx)])
ylim([2 8])
legend('xCoG','yCoG')
path=pwd;
try
    cd(fullfile(path,'COP_reports'))
catch
    disp('create data folder in the main folder')
end

Fig2 = figure;
copyobj(handles.aux_plot, Fig2);
axesHandles = findall(Fig2,'type','axes');
axesPosition=get(axesHandles,'position');  %This uses the a file exchange function
%axesHandles = findall(h,'type','axes');  %OR this uses a built-in function, which sometimes fails if the plot box is manually changed using functions such as "axis square"
windowPosition=get(gcf,'position');
set(gcf,'position',[488   342   370   200]);
maskval=get(handles.max_num,'Value');
saveas(Fig2,strcat(handles.fileName,'_',handles.max_num.String,'%_plot.png'));
close gcf

report=[COGx',COGy'];
csvwrite(strcat(handles.fileName,'_',handles.max_num.String,'%_cog.csv'),report);

try
    cd(strcat(path))
catch
    disp('folder')
end


% --- Executes on slider movement.
function slider_max_Callback(hObject, eventdata, handles)
% hObject    handle to slider_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
position=get(hObject,'Value');
set(hObject,'Value',round(position,1));
set(handles.max_num,'String',num2str(round(position,1)));
max_num_Callback(hObject, eventdata, handles);
% handles.max=str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function slider_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
