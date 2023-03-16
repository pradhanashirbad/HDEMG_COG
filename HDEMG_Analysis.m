function varargout = HDEMG_Analysis(varargin)
% HDEMG_ANALYSIS MATLAB code for HDEMG_Analysis.fig
%
% Author: Ashirbad Pradhan, 2023.
%
%      HDEMG_ANALYSIS, by itself, creates a new HDEMG_ANALYSIS or raises the existing
%      singleton*.
%
%      H = HDEMG_ANALYSIS returns the handle to a new HDEMG_ANALYSIS or the handle to
%      the existing singleton*.
%
%      HDEMG_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HDEMG_ANALYSIS.M with the given input arguments.
%
%      HDEMG_ANALYSIS('Property','Value',...) creates a new HDEMG_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HDEMG_Analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HDEMG_Analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HDEMG_Analysis

% Last Modified by GUIDE v2.5 14-Mar-2023 14:32:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @HDEMG_Analysis_OpeningFcn, ...
    'gui_OutputFcn',  @HDEMG_Analysis_OutputFcn, ...
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


% --- Executes just before HDEMG_Analysis is made visible.
function HDEMG_Analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HDEMG_Analysis (see VARARGIN)

if nargin<4
    disp('incorrect mode ------------ run HDEMGMainProg.m')
    n_plots=1;
elseif nargin==4
    handles.controlObject = varargin{1};
    n_plots=1;
elseif nargin==5 && isnumeric(varargin{2})
    handles.controlObject = varargin{1};
    n_plots = varargin{2};
else
    disp('Error: too many inputs, displaying dummy data')
end

% Choose default command line output for HDEMG_Analysis
handles.output = hObject;
config;
handles.f_samp=F_SAMP;
% set default window size
switch round(WINDOW_SIZE_MS/125)
    case 1 %32 x 2
        set(handles.btn_samp(1),'Value',1);
    case 2
        set(handles.btn_samp(2),'Value',1);
    case 4
        set(handles.btn_samp(3),'Value',1);
    case 8
        set(handles.btn_samp(4),'Value',1);
    otherwise
        disp('Incorrect Window Size Selection, choosing Default Value')
end
handles.result = {};
%set up screen
set(handles.txt_busy,'Visible', 'On');

% Set mapping plots
switch n_plots
    case 1 % 64x1 or 32x1
        handles.pax(1) = subplot(n_plots,2,1,'Parent', handles.panel_map);
        set(handles.pax(1),'Position', [0.05, 0.03, 0.75, 0.96])
    case 2 %32 x 2 or %64 x 2
        handles.pax(1) = subplot(n_plots,2,1,'Parent', handles.panel_map);
        handles.pax(2) = subplot(n_plots,2,2,'Parent', handles.panel_map);
        set(handles.pax(1),'Position', [0.05, 0.05, 0.5, 0.9])
        set(handles.pax(2),'Position', [0.55, 0.05, 0.5, 0.9])

    case 3 %32 x 2 or %64 x 2
        handles.pax(1) = subplot(n_plots,3,1,'Parent', handles.panel_map);
        handles.pax(2) = subplot(n_plots,3,2,'Parent', handles.panel_map);
        handles.pax(3) = subplot(n_plots,3,3,'Parent', handles.panel_map);
        
        set(handles.pax(1),'Position', [0.01, 0.05, 0.32, 0.9])
        set(handles.pax(2),'Position', [0.35, 0.05, 0.32, 0.9])
        set(handles.pax(3),'Position', [0.69, 0.05, 0.35, 0.9])

    case 4 %32 x 2 or %64 x 2
        handles.pax(1) = subplot(n_plots,4,1,'Parent', handles.panel_map);
        handles.pax(2) = subplot(n_plots,4,2,'Parent', handles.panel_map);
        handles.pax(3) = subplot(n_plots,4,3,'Parent', handles.panel_map);
        handles.pax(4) = subplot(n_plots,4,4,'Parent', handles.panel_map);
        
        set(handles.pax(1),'Position', [0.01, 0.05, 0.26, 0.9])
        set(handles.pax(2),'Position', [0.25, 0.05, 0.26, 0.9])
        set(handles.pax(3),'Position', [0.5, 0.05, 0.26, 0.9])
        set(handles.pax(4),'Position', [0.75, 0.05, 0.26, 0.9])
    otherwise
        disp('invalid layout, try another')
end


% Dummy
rawdata = randn(10000,28);
disp('dummy data loaded');
Data_rms=rawdata(1,1:28);


% Update map
% for i = 1:length(handles.pax)
%     axes(handles.pax(i))
%     [handles.xcg,handles.ycg]=map_8x4(handles.controlObject,Data_rms);
% end
set(handles.txt_busy,'Visible', 'Off');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HDEMG_Analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HDEMG_Analysis_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popup_feature.
function popup_feature_Callback(hObject, eventdata, handles)
% hObject    handle to popup_feature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.txt_busy, 'Visible','on'); pause(0.01);
handles.controlObject = handles.controlObject.load_defaults();
[filterFlag, bipolarFlag, featureVal] = handles.controlObject.get_processing_settings();
handles.controlObject = handles.controlObject.sigpro(filterFlag, bipolarFlag, featureVal);
if (handles.controlObject.lastIndex > 0)
    [handles.result,handles.controlObject] = handles.controlObject.update_layout(handles.controlObject.lastIndex);
else
    handles.controlObject = handles.controlObject.load_layout();
end
set(handles.txt_busy, 'Visible','off');
guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns popup_feature contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_feature


% --- Executes during object creation, after setting all properties.
function popup_feature_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_feature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edt_filename_Callback(hObject, eventdata, handles)
% hObject    handle to edt_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_filename as text
%        str2double(get(hObject,'String')) returns contents of edt_filename as a double


% --- Executes during object creation, after setting all properties.
function edt_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edt_mapmin_Callback(hObject, eventdata, handles)
% hObject    handle to edt_mapmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_mapmin as text
%        str2double(get(hObject,'String')) returns contents of edt_mapmin as a double


% --- Executes during object creation, after setting all properties.
function edt_mapmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_mapmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edt_mapmax_Callback(hObject, eventdata, handles)
% hObject    handle to edt_mapmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_mapmax as text
%        str2double(get(hObject,'String')) returns contents of edt_mapmax as a double



% --- Executes during object creation, after setting all properties.
function edt_mapmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_mapmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in btn_cursor.
function btn_cursor_Callback(hObject, eventdata, handles)
% hObject    handle to btn_cursor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.txt_busy, 'Visible','on');
xcord=ginput(1)*1000;
samplenum = round(xcord(1));
sampf_adjusted = round(samplenum*handles.f_samp/1000);
[handles.result,handles.controlObject] = handles.controlObject.update_layout(sampf_adjusted);
set(handles.txt_busy, 'Visible','off');
set(handles.edt_indexnum,'String',num2str(sampf_adjusted));
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of btn_cursor


% --- Executes on button press in btn_export.
function btn_export_Callback(hObject, eventdata, handles)
% hObject    handle to btn_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%if isfile(Repoe)
filename = get(handles.edt_exportfilename,'String');
try
    %Check if an Excel server is running
    ex = actxGetRunningServer('Excel.Application');
catch ME
    %disp(ME.message)
end
if exist('ex','var')
    %Get the names of all open Excel files
    wbs = ex.Workbooks;
    %List the entire path of all excel workbooks that are currently open
    for i = 1:wbs.Count
        if strcmp(wbs.Item(i).FullName,fullfile(pwd,filename))
            wbs.Item(i).Save;
            wbs.Item(i).Close;
            %ex.Quit;
        end
    end
end
if ~isfile(filename)
    writecell(handles.result,filename)
else
    writecell(handles.result,filename,'WriteMode','append')
end

if ispc
    winopen(filename)
end
   

% dlmwrite(handles.outfilename,[values],'-append')


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
try
    handles.controlObject.hLayout = [];
end


% --- Executes when selected object is changed in btngroup_window.
function btngroup_window_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in btngroup_window
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.controlObject = handles.controlObject.load_defaults();
handles.controlObject.epochsize = get_windowsize(handles);
set(handles.txt_busy, 'Visible','on'); pause(0.01);
[filterFlag, bipolarFlag, featureVal] = handles.controlObject.get_processing_settings();
handles.controlObject = handles.controlObject.sigpro(filterFlag, bipolarFlag, featureVal);
if (handles.controlObject.lastIndex > 0)
    [handles.result,handles.controlObject] = handles.controlObject.update_layout(handles.controlObject.lastIndex);
else
    handles.controlObject = handles.controlObject.load_layout();
end
set(handles.txt_busy, 'Visible','off');
guidata(hObject,handles)


% --- Executes when selected object is changed in btngroup_window.
function y = get_windowsize(handles)% hObject    handle to the selected object in btngroup_sp
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wsize = get(handles.btn_samp,'Value')';
if wsize{1}
    y=round(125*handles.f_samp/1000);
elseif wsize{2}
    y=round(250*handles.f_samp/1000);
elseif wsize{3}
    y=round(500*handles.f_samp/1000);
elseif wsize{4}
    y=round(1000*handles.f_samp/1000);
end


% --- Executes on button press in btn_updateminmax.
function btn_updateminmax_Callback(hObject, eventdata, handles)
% hObject    handle to btn_updateminmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.controlObject.change_minmax();



function edt_indexnum_Callback(hObject, eventdata, handles)
% hObject    handle to edt_indexnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_indexnum as text
%        str2double(get(hObject,'String')) returns contents of edt_indexnum as a double
try
set(handles.txt_busy, 'Visible','on');
samplenum = str2double(get(hObject,'String'));
[handles.result,handles.controlObject] = handles.controlObject.update_layout(samplenum);
set(handles.txt_busy, 'Visible','off');
guidata(hObject,handles)
catch
    disp("Entry Error: Enter valid index number")
end

% --- Executes during object creation, after setting all properties.
function edt_indexnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_indexnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
