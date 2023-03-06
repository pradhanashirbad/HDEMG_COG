function varargout = HDEMG_Settings(varargin)
% HDEMG_SETTINGS MATLAB code for HDEMG_Settings.fig
%
% Author: Ashirbad Pradhan, 2023.
%
%      HDEMG_SETTINGS, by itself, creates a new HDEMG_SETTINGS or raises the existing
%      singleton*.
%
%      H = HDEMG_SETTINGS returns the handle to a new HDEMG_SETTINGS or the handle to
%      the existing singleton*.
%
%      HDEMG_SETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HDEMG_SETTINGS.M with the given input arguments.
%
%      HDEMG_SETTINGS('Property','Value',...) creates a new HDEMG_SETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HDEMG_Settings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HDEMG_Settings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HDEMG_Settings

% Last Modified by GUIDE v2.5 01-Mar-2023 12:05:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HDEMG_Settings_OpeningFcn, ...
                   'gui_OutputFcn',  @HDEMG_Settings_OutputFcn, ...
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


% --- Executes just before HDEMG_Settings is made visible.
function HDEMG_Settings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and handles.controlObject.fileNameuser data (see GUIDATA)
% varargin   command line arguments to HDEMG_Settings (see VARARGIN)

% Load configs
config;

% Choose default command line output for HDEMG_Settings
handles.output = hObject;
handles.toolpath = fullfile(SETTINGS_PATH);
%input arguments
if nargin<4
    disp('incorrect mode ----- run HDEMGMainProg.m')
else
    handles.controlObject=varargin{1};
end

% remove extra entries normalize
set(handles.edt_mvcval(length(GRID_CONFIG)+1:end),'Visible','off')
set(handles.txt_mvc(length(GRID_CONFIG)+1:end),'Visible','off')

handles.grid_config = GRID_CONFIG;
% remove extra entries cci
contents_agon = cellstr(get(handles.popup_agon,'String'));
contents_agon(length(GRID_CONFIG)+1:end)=[];
set(handles.popup_agon,'String',contents_agon)
contents_anta = cellstr(get(handles.popup_antagon,'String'));
contents_anta(length(GRID_CONFIG)+1:end)=[];
set(handles.popup_antagon,'String',contents_anta)

% Set defaults
set(handles.edt_datapath, 'String', DATA_PATH);
set(handles.edt_mvcval,'Enable','Off');
set(handles.chk_cci,'Value',0);
set(handles.btn_loadanalysis,'Enable','Off');
set(handles.txt_filename,'String','');
set(handles.txt_ngrids,'String','');
set(handles.txt_columns,'String','');
set(handles.txt_rows,'String','');

%set cci defaults
set(handles.popup_agon,'Enable','Off');
set(handles.popup_antagon,'Enable','Off');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HDEMG_Settings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HDEMG_Settings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popup_layout.
function popup_layout_Callback(hObject, eventdata, handles)
% hObject    handle to popup_layout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_layout contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_layout



% --- Executes during object creation, after setting all properties.
function popup_layout_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_layout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_loadfile.
function btn_loadfile_Callback(hObject, eventdata, handles)
% hObject    handle to btn_loadfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles=guidata(hObject);
oldfolder = cd(get(handles.edt_datapath,'String'));
handles.controlObject.fileName=uigetfile({'*.*'},...
                          'File Selector');
if handles.controlObject.fileName==0
  % user pressed cancel
  disp('incorrect file, try again')
  cd(oldfolder); % go back to original directory
  return
end
cd(oldfolder);
try
    handles.controlObject = handles.controlObject.load_defaults();
    [Data,handles.controlObject] = handles.controlObject.load_data();
catch ME
    disp('Loading File Error: Select Proper File');
    return
end
set(handles.txt_filename,'String',handles.controlObject.fileName);
set(handles.txt_columns,'String',int2str(size(Data,2)));
set(handles.txt_rows,'String',int2str(size(Data,1)));
set(handles.btn_loadanalysis,'Enable','On');
set(handles.txt_ngrids,'String',num2str(length(handles.controlObject.grid_config)));
guidata(hObject, handles);


function edt_datapath_Callback(hObject, eventdata, handles)
% hObject    handle to edt_datapath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_datapath as text
%        str2double(get(hObject,'String')) returns contents of edt_datapath as a double
if ~exist(get(hObject,'String'))
    set(handles.edt_datapath, 'String', pwd);
end



% --- Executes during object creation, after setting all properties.
function edt_datapath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_datapath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edt_aux_Callback(hObject, eventdata, handles)
% hObject    handle to edt_aux (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_aux as text
%        str2double(get(hObject,'String')) returns contents of edt_aux as a double
if (str2double(get(hObject,'String')) > str2double(get(handles.txt_columns,'String')))
    set(hObject,'String',get(handles.txt_columns,'String'))
end


% --- Executes during object creation, after setting all properties.
function edt_aux_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_aux (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chk_aux.
function chk_aux_Callback(hObject, eventdata, handles)
% hObject    handle to chk_aux (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_aux
if get(hObject,'Value')
    set(handles.edt_aux,'Enable','on')
else
    set(handles.edt_aux,'Enable','off')
end


% --- Executes on button press in btn_loadanalysis.
function btn_loadanalysis_Callback(hObject, eventdata, handles)
% hObject    handle to btn_loadanalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%process the signals based on settings
try
    handles.controlObject = handles.controlObject.load_defaults();
    handles.controlObject = handles.controlObject.get_entries_from_settings();    
    handles.controlObject = handles.controlObject.validate_layout(); 
catch ME
    disp('Validation Error: Update config and select correct layout');
    return
end
try
    [filterFlag, bipolarFlag, featureVal] = handles.controlObject.get_processing_settings();
    handles.controlObject = handles.controlObject.sigpro(filterFlag, bipolarFlag, featureVal);
catch ME
    disp('Processing Error: Select Proper File');
    return
end
try
    handles.controlObject = handles.controlObject.load_layout();
    [handles.result,handles.controlObject] = handles.controlObject.update_layout([]);   
catch ME
    disp('Loading Layout Error: Select Proper File and layout settings');
    return
end
 

%setuplayout(handles,normEMG);

% --- Executes on button press in chk_bpfilter.
function chk_bpfilter_Callback(hObject, eventdata, handles)
% hObject    handle to chk_bpfilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: etet(hObject,'Value') returns toggle state of chk_bpfilter


% --- Executes on button press in chk_bipolar.
function chk_bipolar_Callback(hObject, eventdata, handles)
% hObject    handle to chk_bipolar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_bipolar



function edt_mvcval_Callback(hObject, eventdata, handles)
% hObject    handle to edt_mvcval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_mvcval as text
%        str2double(get(hObject,'String')) returns contents of edt_mvcval as a double


% --- Executes during object creation, after setting all properties.
function edt_mvcval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_mvcval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.btn_norm1,'Value')
    set(handles.edt_mvcval(:),'Enable','On');
else
    set(handles.edt_mvcval(:),'Enable','Off');
end    


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
try
cd(handles.toolpath)
delete(hObject);
handles.controlObject.hSettings = [];
end


% --- Executes on button press in chk_cci.
function chk_cci_Callback(hObject, eventdata, handles)
% hObject    handle to chk_cci (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_cci
if get(hObject,'Value')
    set(handles.popup_agon,'Enable','On');
    set(handles.popup_antagon,'Enable','On');
else
    set(handles.popup_agon,'Enable','Off');
    set(handles.popup_antagon,'Enable','Off');
end  


% --- Executes on selection change in popup_agon.
function popup_agon_Callback(hObject, eventdata, handles)
% hObject    handle to popup_agon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_agon contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_agon


% --- Executes during object creation, after setting all properties.
function popup_agon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_agon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_antagon.
function popup_antagon_Callback(hObject, eventdata, handles)
% hObject    handle to popup_antagon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_antagon contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_antagon


% --- Executes during object creation, after setting all properties.
function popup_antagon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_antagon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
