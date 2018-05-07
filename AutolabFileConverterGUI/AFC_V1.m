function varargout = AFC_V1(varargin)
% AFC_V1 MATLAB code for AFC_V1.fig
%      AFC_V1, by itself, creates a new AFC_V1 or raises the existing
%      singleton*.
%
%      H = AFC_V1 returns the handle to a new AFC_V1 or the handle to
%      the existing singleton*.
%
%      AFC_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFC_V1.M with the given input arguments.
%
%      AFC_V1('Property','Value',...) creates a new AFC_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AFC_V1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AFC_V1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AFC_V1

% Last Modified by GUIDE v2.5 14-Mar-2018 13:28:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AFC_V1_OpeningFcn, ...
                   'gui_OutputFcn',  @AFC_V1_OutputFcn, ...
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


% --- Executes just before AFC_V1 is made visible.
function AFC_V1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AFC_V1 (see VARARGIN)

% Choose default command line output for AFC_V1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AFC_V1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AFC_V1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in import_data.
function import_data_Callback(hObject, eventdata, handles)
% hObject    handle to import_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
import_type=get(get(handles.import_type,'SelectedObject'), 'tag');

input_id=get(handles.input_id,'string');
if iscell(input_id)==1
   input_id=input_id{1,1}; 
end

input_day=get(handles.input_day,'string');
if iscell(input_day)==1
   input_day=input_day{1,1}; 
end

input_startrow=get(handles.input_startrow,'string');
if iscell(input_startrow)==1
   input_startrow=input_startrow{1,1}; 
end

input_delimiter=get(handles.input_delimiter,'string');
if iscell(input_delimiter)==1
   input_delimiter=input_delimiter{1,1}; 
end

if strcmp(import_type,'input_text')==1

if isfield(handles,'path') == 1
    [filenames, pathname, filterindex] = uigetfile( ...
    {  '*.txt','Autolab Text Files (*.txt)'; ...
       '*.*',  'All Files (*.*)'}, ...
       'Pick a file', ...
       handles.path, ...
       'MultiSelect', 'on');
else
    [filenames, pathname, filterindex] = uigetfile( ...
    {  '*.txt','Autolab Text Files (*.txt)'; ...
       '*.*',  'All Files (*.*)'}, ...
       'Pick a file', ...
       'MultiSelect', 'on');
end


    set(handles.listbox1,'String',filenames);

    [~,filenum]=size(filenames);

    %[/New Code]

    %[New Code - EA
    %The code below extracts data from the pre-structured Autolab text files.
    %If the Autolab export format changes from what I'm currently using, the
    %code below will stop working.
    %EXAMPLE FORMAT
    %{
    Frequency (Hz)	Z' (?)	-Z'' (?)
    29999.7329711914	25184.3314854204	355874.775433015
    28819.7994232178	26485.2993485669	370635.207440551
    %}
    for i = 1:filenum
        filename=filenames{1,i};
        fullname=strcat(pathname,filename);
        delimiter = input_delimiter;
        startRow = str2num(input_startrow);

        formatSpec = '%f%f%f%*s%*s%[^\n\r]';

        fileID = fopen(fullname,'r','n','UTF-8');
        fseek(fileID, 3, 'bof');
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
        fclose(fileID);
        %Generage storage variable based on user input.
        %RESTRICTION: User must import either 16 files or 5 channels at the moment.

        data_storage{i,:}=[dataArray{1:end-1}];
    end

    % eval_command = sprintf('handles.%s_Day%s_Channels1to%s{i,:}=data_storage;', input_id, input_day, input_channels);
    % eval(eval_command);

    handles.data_storage=data_storage;
    handles.saved_input_id=input_id;
    handles.saved_input_day=input_day;
    handles.input_channels=filenum;
    handles.filenames=filenames;
    handles.path=pathname;
    
    set(handles.update_user,'String','Data Successfully Imported');
    set(handles.update_user,'BackgroundColor',[0 1 0]);
end

guidata(hObject, handles);

function input_id_Callback(hObject, eventdata, handles)
% hObject    handle to input_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_id as text
%        str2double(get(hObject,'String')) returns contents of input_id as a double
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function input_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_day_Callback(hObject, eventdata, handles)
% hObject    handle to input_day (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_day as text
%        str2double(get(hObject,'String')) returns contents of input_day as a double


% --- Executes during object creation, after setting all properties.
function input_day_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_day (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_startrow_Callback(hObject, eventdata, handles)
% hObject    handle to input_startrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_startrow as text
%        str2double(get(hObject,'String')) returns contents of input_startrow as a double


% --- Executes during object creation, after setting all properties.
function input_startrow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_startrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_delimiter_Callback(hObject, eventdata, handles)
% hObject    handle to input_delimiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_delimiter as text
%        str2double(get(hObject,'String')) returns contents of input_delimiter as a double


% --- Executes during object creation, after setting all properties.
function input_delimiter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_delimiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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


% --- Executes on button press in export_data.
function export_data_Callback(hObject, eventdata, handles)
% hObject    handle to export_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input_freq=get(handles.input_freq,'string');
if iscell(input_freq)==1
   input_freq=input_freq{1,1}; 
end
input_freq=str2num(input_freq);

input_z=get(handles.input_z,'string');
if iscell(input_z)==1
   input_z=input_z{1,1}; 
end
input_z=str2num(input_z);

input_negz=get(handles.input_negz,'string');
if iscell(input_negz)==1
   input_negz=input_negz{1,1}; 
end
input_negz=str2num(input_negz);

input_impmag=get(handles.input_impmag,'string');
if iscell(input_impmag)==1
   input_impmag=input_impmag{1,1}; 
end
input_impmag=str2num(input_impmag);

input_phase=get(handles.input_phase,'string');
if iscell(input_phase)==1
   input_phase=input_phase{1,1}; 
end
input_phase=str2num(input_phase);

input_merge=get(handles.input_merge,'Value');

input_id=get(handles.input_id,'string');
if iscell(input_id)==1
   input_id=input_id{1,1}; 
end

input_day=get(handles.input_day,'string');
if iscell(input_day)==1
   input_day=input_day{1,1}; 
end

input_startrow=get(handles.input_startrow,'string');
if iscell(input_startrow)==1
   input_startrow=input_startrow{1,1}; 
end

input_delimiter=get(handles.input_delimiter,'string');
if iscell(input_delimiter)==1
   input_delimiter=input_delimiter{1,1}; 
end

pathname=handles.path;
data_storage=handles.data_storage;
input_channels=handles.input_channels;

writepath = uigetdir(pathname);


for i = 1:input_channels
    datapoints=length(data_storage{i,1});
    for j = 1:datapoints
            %Calculate impedance magnitude and place in user column
            %impmag=sqrt(z^2+(-z)^2)
            data_storage{i,1}(j,input_impmag)=sqrt((data_storage{i,1}(j,input_z))^2+(data_storage{i,1}(j,input_negz))^2);
            
            %Calculate impedance phase and place in user column
            %(360/(2pi))*atan(-z/z)
            data_storage{i,1}(j,input_phase)=(360/(2*pi))*atan((data_storage{i,1}(j,input_negz))/(data_storage{i,1}(j,input_z)));
    end        
end

filename=sprintf('Processed_%s_Day%s_Channels1to%s',input_id,input_day,num2str(input_channels));
    
writestring=sprintf('%s\\%s',writepath,filename);

eval_command=sprintf('%s=data_storage;',filename);
eval(eval_command);
    
save(writestring,filename);

set(handles.update_user,'String','No Files Loaded');
set(handles.update_user,'BackgroundColor',[0.94 0.94 0.94]);
set(handles.listbox1,'String','');

guidata(hObject, handles);


function input_freq_Callback(hObject, eventdata, handles)
% hObject    handle to input_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_freq as text
%        str2double(get(hObject,'String')) returns contents of input_freq as a double


% --- Executes during object creation, after setting all properties.
function input_freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_z_Callback(hObject, eventdata, handles)
% hObject    handle to input_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_z as text
%        str2double(get(hObject,'String')) returns contents of input_z as a double


% --- Executes during object creation, after setting all properties.
function input_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_negz_Callback(hObject, eventdata, handles)
% hObject    handle to input_negz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_negz as text
%        str2double(get(hObject,'String')) returns contents of input_negz as a double


% --- Executes during object creation, after setting all properties.
function input_negz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_negz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_channels_Callback(hObject, eventdata, handles)
% hObject    handle to input_channels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_channels as text
%        str2double(get(hObject,'String')) returns contents of input_channels as a double


% --- Executes during object creation, after setting all properties.
function input_channels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_channels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_impmag_Callback(hObject, eventdata, handles)
% hObject    handle to input_impmag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_impmag as text
%        str2double(get(hObject,'String')) returns contents of input_impmag as a double


% --- Executes during object creation, after setting all properties.
function input_impmag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_impmag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_phase_Callback(hObject, eventdata, handles)
% hObject    handle to input_phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_phase as text
%        str2double(get(hObject,'String')) returns contents of input_phase as a double


% --- Executes during object creation, after setting all properties.
function input_phase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in input_text.
function input_text_Callback(hObject, eventdata, handles)
% hObject    handle to input_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of input_text


% --- Executes on button press in input_mat.
function input_mat_Callback(hObject, eventdata, handles)
% hObject    handle to input_mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of input_mat


% --- Executes on button press in input_merge.
function input_merge_Callback(hObject, eventdata, handles)
% hObject    handle to input_merge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of input_merge
