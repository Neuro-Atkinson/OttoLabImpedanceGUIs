function varargout = IG_V1(varargin)
% IG_V1 MATLAB code for IG_V1.fig
%      IG_V1, by itself, creates a new IG_V1 or raises the existing
%      singleton*.
%
%      H = IG_V1 returns the handle to a new IG_V1 or the handle to
%      the existing singleton*.
%
%      IG_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IG_V1.M with the given input arguments.
%
%      IG_V1('Property','Value',...) creates a new IG_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IG_V1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IG_V1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IG_V1

% Last Modified by GUIDE v2.5 13-Mar-2018 13:01:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IG_V1_OpeningFcn, ...
                   'gui_OutputFcn',  @IG_V1_OutputFcn, ...
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

% --- Executes just before IG_V1 is made visible.
function IG_V1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IG_V1 (see VARARGIN)

% Choose default command line output for IG_V1
handles.output = hObject;

handles.previous_figure_zz=0;
handles.previous_figure_im=0;
handles.previous_figure_ph=0;
handles.previous_figure_avgimp=0;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes IG_V1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IG_V1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on button press in load_data.
function load_data_Callback(hObject, eventdata, handles)
% hObject    handle to load_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName,~] = uigetfile('*.mat','Select processed data');
if isequal(FileName,0)
   handles=buttons_on(hObject,handles);
   set(handles.unvetted_txt,'String','No Files Loaded');
   return;
end



combinedname=sprintf('%s%s',PathName,FileName);
loaded_data=load(combinedname,'-mat');

field_string=fields(loaded_data);

[~,columns]=size(loaded_data.(field_string{1,1}));

if columns==1 %indicates a non-merged processed file was loaded
    FileName=FileName(1:end-4);
    temp_convert{1,1}=loaded_data.(field_string{1,1});
    temp_convert{2,1}=0;
    temp_convert{3,1}=FileName;
    
    
    handles.data=temp_convert;
else
   handles.data=loaded_data.(field_string{1,1});
end



[~,days]=size(handles.data);

handles.days=days;


for i = 1:days
    file_names(i,1)=handles.data(3,i);
end


[channels,~]=size(handles.data{1,1});

channel_input_update=sprintf('[1:%s]',num2str(channels));
set(handles.channels_input,'string',channel_input_update);

days_input_update=sprintf('[1:%s]',num2str(days));
set(handles.days_input,'string',days_input_update);

for i = 1:channels
    channel_names{i,1}=sprintf('Channel %s',num2str(i));
end

[freqnum,~]=size(handles.data{1,1}{1,1}(:,1));
for i = 1:freqnum
    freq_names{i,1}=sprintf('%s = %s',num2str(i),num2str(handles.data{1,1}{1,1}(i,1)));
end



set(handles.listbox1,'String',file_names);
set(handles.listbox2,'String',channel_names);
set(handles.freq_list,'String',freq_names);

freq_input=sprintf('[1:%s]',num2str(freqnum));
set(handles.frequency_input,'String',freq_input);

handles.maxfreqrange=freq_input;
handles.day=1;
handles.channel=1;

guidata(hObject, handles);

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
handles.day=get(hObject,'Value');

guidata(hObject, handles);

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


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
handles.channel=get(hObject,'Value');

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function days_input_Callback(hObject, eventdata, handles)
% hObject    handle to days_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of days_input as text
%        str2double(get(hObject,'String')) returns contents of days_input as a double


% --- Executes during object creation, after setting all properties.
function days_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to days_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function channels_input_Callback(hObject, eventdata, handles)
% hObject    handle to channels_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of channels_input as text
%        str2double(get(hObject,'String')) returns contents of channels_input as a double


% --- Executes during object creation, after setting all properties.
function channels_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channels_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in scatter.
function scatter_Callback(hObject, eventdata, handles)
% hObject    handle to scatter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scatter


% --- Executes on button press in simple_plot.
function simple_plot_Callback(hObject, eventdata, handles)
% hObject    handle to simple_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of simple_plot


% --- Executes on button press in new_figure.
function new_figure_Callback(hObject, eventdata, handles)
% hObject    handle to new_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of new_figure


% --- Executes on button press in plot1.
function plot1_Callback(hObject, eventdata, handles)
% hObject    handle to plot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot1


% --- Executes on button press in plot2.
function plot2_Callback(hObject, eventdata, handles)
% hObject    handle to plot2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot2


% --- Executes on button press in plot3.
function plot3_Callback(hObject, eventdata, handles)
% hObject    handle to plot3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot3

% --- Executes on button press in plot_data.
function plot_data_Callback(hObject, eventdata, handles)
% hObject    handle to plot_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
days_input=get(handles.days_input,'string');
if iscell(days_input)==1
    days_input=days_input{1,1};
end
days_input=str2num(days_input);
channels_input=get(handles.channels_input,'string');
if iscell(channels_input)==1
   channels_input=channels_input{1,1}; 
end

plot_offset_input=get(handles.plot_offset_input,'String');
if iscell(plot_offset_input)==1
   plot_offset_input=plot_offset_input{1,1}; 
end
plot_offset_input=str2num(plot_offset_input);

frequency_input=get(handles.frequency_input,'string');
avg_freq_input=get(handles.avg_freq,'string');
avg_freq_input=str2num(avg_freq_input);

color_custom_input=get(handles.color_custom_input,'String');
if iscell(color_custom_input)==1
   color_custom_input=color_custom_input{1,1}; 
end
plot_color_group=get(get(handles.plot_color_group,'SelectedObject'),'tag');

plot_options=get(get(handles.plot_options,'SelectedObject'), 'tag');
plot_type=get(get(handles.plot_type,'SelectedObject'), 'tag');

use_labels=get(handles.use_labels,'Value');
show_scatter=get(handles.data_scatter,'Value');

use_freq=get(handles.use_freq,'Value');
use_chans=get(handles.use_chans,'Value');
use_days=get(handles.use_days,'Value');
avg_chans=get(handles.avg_chans,'Value');
use_plotcolor=get(handles.use_plotcolor,'Value');
use_plot_offset=get(handles.use_plot_offset,'Value');
use_avgimplog=get(handles.use_avgimplog,'Value');


days=handles.days;

selected_day=handles.day;
selected_channel=handles.channel;

simple_plot=get(handles.simple_plot,'Value');
daily_plotter=get(handles.daily_plotter,'Value');


xaxis_input_zz=get(handles.xaxis_input_zz,'String');
yaxis_input_zz=get(handles.yaxis_input_zz,'String');
plottitle_input_zz=get(handles.plottitle_input_zz,'String');


xaxis_input_imp=get(handles.xaxis_input_imp,'String');
yaxis_input_imp=get(handles.yaxis_input_imp,'String');
plottitle_input_imp=get(handles.plottitle_input_imp,'String');


xaxis_input_ph=get(handles.xaxis_input_ph,'String');
yaxis_input_ph=get(handles.yaxis_input_ph,'String');
plottitle_input_ph=get(handles.plottitle_input_ph,'String');

xaxis_input_impmag=get(handles.xaxis_input_avgimp,'String');
yaxis_input_impmag=get(handles.yaxis_input_avgimp,'String');
plottitle_input_impmag=get(handles.plottitle_input_avgimp,'String');

maxfreqrange=handles.maxfreqrange;

chan_map=str2num(channels_input);
chan_num=length(chan_map);

%ZvzZ
plot1=get(handles.plot1,'Value');
%ImpMag
plot2=get(handles.plot2,'Value');
%Phase
plot3=get(handles.plot3,'Value');
%ImpMag Over Time
plot4=get(handles.plot4,'Value');

new_figure=get(handles.new_figure,'Value');

if simple_plot==1
    if new_figure==1
        if plot1==1
            handles.previous_figure_zz=figure;
        end
        if plot2==1
            handles.previous_figure_im=figure;
        end
        if plot3==1
            handles.previous_figure_ph=figure;
        end
    else
        if plot1==1 && handles.previous_figure_zz==0
            handles.previous_figure_zz=figure;
        end
        if plot2==1 && handles.previous_figure_im==0
            handles.previous_figure_im=figure;
        end
        if plot3==1 && handles.previous_figure_ph==0
            handles.previous_figure_ph=figure;
        end
    end

    
    totalplots=plot1+plot2+plot3;
    
   
    if strcmp('overlay',plot_type) == 1
        if plot1==1
            figure(handles.previous_figure_zz);
            hold all;
        end
        if plot2==1
           figure(handles.previous_figure_im);
           hold all;
        end
        if plot3==1
            figure(handles.previous_figure_ph);
            hold all
        end
    end 

    if plot1 == 1
        figure(handles.previous_figure_zz);
        if use_freq==1
            scatter(handles.data{1,selected_day}{selected_channel,1}(str2num(frequency_input),2),handles.data{1,selected_day}{selected_channel,1}(str2num(frequency_input),3),1)
        else
            scatter(handles.data{1,selected_day}{selected_channel,1}(str2num(maxfreqrange),2),handles.data{1,selected_day}{selected_channel,1}(str2num(maxfreqrange),3),1)
        end    
        if use_labels==1
           xlabel(xaxis_input_zz)
           ylabel(yaxis_input_zz)
           title(plottitle_input_zz)
        end
    end
    if plot2 == 1
        figure(handles.previous_figure_im);
        if use_freq==1
            scatter(log(handles.data{1,selected_day}{selected_channel,1}(str2num(frequency_input),1)),log(handles.data{1,selected_day}{selected_channel,1}(str2num(frequency_input),4)));
        else
            scatter(log(handles.data{1,selected_day}{selected_channel,1}(str2num(maxfreqrange),1)),log(handles.data{1,selected_day}{selected_channel,1}(str2num(maxfreqrange),4)));     
        end
        if use_labels==1
           xlabel(xaxis_input_imp)
           ylabel(yaxis_input_imp)
           title(plottitle_input_imp)
        end
    end
    if plot3 == 1
        figure(handles.previous_figure_ph);
        if use_freq==1
            scatter(log(handles.data{1,selected_day}{selected_channel,1}(str2num(frequency_input),1)),handles.data{1,selected_day}{selected_channel,1}(str2num(frequency_input),5)); 
        else
            scatter(log(handles.data{1,selected_day}{selected_channel,1}(str2num(maxfreqrange),1)),handles.data{1,selected_day}{selected_channel,1}(str2num(maxfreqrange),5));  
        end
        if use_labels==1
           xlabel(xaxis_input_ph)
           ylabel(yaxis_input_ph)
           title(plottitle_input_ph)
        end
    end

end

if daily_plotter==1
    if plot2==1
        daily_plot_fig=figure('rend','painters','pos',[100 100 1300 1200]);
      background_color=get(daily_plot_fig,'Color');
      
      for chan = 1:(chan_num) %ASSUME THERE IS A NOISE CHANNEL HERE SO ONLY PLOT 1-20 TO EXCLUDE NOISE CHANNEL
          if chan > 20
              msgbox('GUI does not currently support more than 20 channels')
          else
              subplot(5,4,chan)
              if use_freq==1
                  %plot(handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(frequency_input),2),handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(frequency_input),3),'Color','k','Marker','+','LineStyle','--','LineWidth',2)
                  scatter(handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(frequency_input),1),handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(frequency_input),4),'MarkerFaceColor','k','MarkerEdgeColor','k','Marker','+')
              else
                  %plot(handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(maxfreqrange),2),handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(maxfreqrange),3),'Color','k','Marker','+','LineStyle','--','LineWidth',2)
                  scatter(handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(maxfreqrange),1),handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(maxfreqrange),4),'MarkerFaceColor','k','MarkerEdgeColor','k','Marker','+')
              end
              grid on
              grid minor
              title(['Site ', num2str(chan)]);
              set(gca,'YScale','log');
              set(gca,'XScale','log');
              hold on
              axis([1e-1 1e5 1e3 1e10]);


    %           
    %         freq_vector=handles.data{1,1}{1,1}(:,1);
    %         freq_difference=abs(freq_vector-1000);
    %         [dif_mag,dif_loc]=min(freq_difference);
    %         nearest_freq=num2str(freq_vector(dif_loc));
    %         
    %         nearest_magnitude=handles.data{1,selected_day}{chan_map(1,chan),1}(dif_loc,3);
    %         nearest_rounded=round(nearest_magnitude);
    %         num_str=addvilgole2(nearest_rounded);
    %         x_string=sprintf('%s Hz Imp Mag: %s Ohms',num2str(nearest_freq),num_str);
    %         xlabel(x_string)
    %         
    %         hold on
    %         scatter(handles.data{1,selected_day}{chan_map(1,chan),1}(dif_loc,2),handles.data{1,selected_day}{chan_map(1,chan),1}(dif_loc,3),'MarkerFaceColor','k','MarkerEdgeColor','r','Marker','d','LineWidth',3)  
         end
       end
    
      %your subplot
    h = axes('Position',[0 0 1 1],'Visible','off'); %add an axes on the left side of your subplots
    set(gcf,'CurrentAxes',h)
    text(.1,.45,'-X (\Omega)',...
    'VerticalAlignment','bottom',...
    'HorizontalAlignment','left', 'Rotation', 90, 'FontSize',14)
    
    text(.5,.02,'R (\Omega)',...
    'VerticalAlignment','bottom',...
    'HorizontalAlignment','center', 'FontSize',14)

    suptitle_string=sprintf('Day: %s Impedance Recording',num2str(selected_day-1));
    text(.5,1,suptitle_string,...
    'VerticalAlignment','Top',...
    'HorizontalAlignment','center', 'FontSize',14)
        
        
    else
      daily_plot_fig=figure('rend','painters','pos',[100 100 1300 1200]);
      background_color=get(daily_plot_fig,'Color');
      
      for chan = 1:(chan_num) %ASSUME THERE IS A NOISE CHANNEL HERE SO ONLY PLOT 1-20 TO EXCLUDE NOISE CHANNEL
          if chan > 20
              msgbox('GUI does not currently support more than 20 channels')
              return;
          end
          subplot(5,4,chan)
          if use_freq==1
              %plot(handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(frequency_input),2),handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(frequency_input),3),'Color','k','Marker','+','LineStyle','--','LineWidth',2)
              scatter(handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(frequency_input),2),handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(frequency_input),3),'MarkerFaceColor','k','MarkerEdgeColor','k','Marker','+')
          else
              %plot(handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(maxfreqrange),2),handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(maxfreqrange),3),'Color','k','Marker','+','LineStyle','--','LineWidth',2)
              scatter(handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(maxfreqrange),2),handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(maxfreqrange),3),'MarkerFaceColor','k','MarkerEdgeColor','k','Marker','+')
          end
          grid on
          title(['Site ', num2str(chan)]);
          
        freq_vector=handles.data{1,1}{1,1}(:,1);
        freq_difference=abs(freq_vector-1000);
        [dif_mag,dif_loc]=min(freq_difference);
        nearest_freq=num2str(freq_vector(dif_loc));
        
        nearest_magnitude=handles.data{1,selected_day}{chan_map(1,chan),1}(dif_loc,3);
        nearest_rounded=round(nearest_magnitude);
        num_str=addvilgole2(nearest_rounded);
        x_string=sprintf('%s Hz Imp Mag: %s Ohms',num2str(nearest_freq),num_str);
        xlabel(x_string)
        
        hold on
        scatter(handles.data{1,selected_day}{chan_map(1,chan),1}(dif_loc,2),handles.data{1,selected_day}{chan_map(1,chan),1}(dif_loc,3),'MarkerFaceColor','k','MarkerEdgeColor','r','Marker','d','LineWidth',3)  
      end
    
      %your subplot
    h = axes('Position',[0 0 1 1],'Visible','off'); %add an axes on the left side of your subplots
    set(gcf,'CurrentAxes',h)
    text(.1,.45,'-X (\Omega)',...
    'VerticalAlignment','bottom',...
    'HorizontalAlignment','left', 'Rotation', 90, 'FontSize',14)
    
    text(.5,.02,'R (\Omega)',...
    'VerticalAlignment','bottom',...
    'HorizontalAlignment','center', 'FontSize',14)

    suptitle_string=sprintf('Day: %s Impedance Recording',num2str(selected_day-1));
    text(.5,1,suptitle_string,...
    'VerticalAlignment','Top',...
    'HorizontalAlignment','center', 'FontSize',14)
    end  
end

if simple_plot == 0 && daily_plotter==0
%Useful vars for this section:
%use_days
%days_input
%days
%channels_input
%use_chans
%avg_chans
%
%

%determine closest frequency location
freq_vector=handles.data{1,1}{1,1}(:,1);
freq_difference=abs(freq_vector-avg_freq_input);
[dif_mag,dif_loc]=min(freq_difference);
nearest_freq=num2str(freq_vector(dif_loc));
update_string=sprintf('Closest Freq: %s',nearest_freq);
set(handles.freq_display,'string',update_string);

day_axis_vector=length(days_input);
day_axis=[1:1:day_axis_vector];

%construct x-axis labels
for day=1:day_axis_vector
    day_axis_label{1,day}=num2str(days_input(1,day)-1);
end


if plot4==1
   %AvgImpMagPlot
   if new_figure == 1
       current_plot=figure;
       handles.previous_figure_avgimp=current_plot;
   else
       if handles.previous_figure_avgimp==0
            current_plot=figure;
            handles.previous_figure_avgimp=current_plot;
       else
           current_plot=handles.previous_figure_avgimp;
       end
   end
   plot_color=[0,0,1];
   
   if use_plotcolor==1
       if strcmp(plot_color_group,'color_red')==1
           plot_color=[1,0,0];
       elseif strcmp(plot_color_group,'color_green')==1
           plot_color=[0,1,0];
       elseif strcmp(plot_color_group,'color_custom')==1
           plot_color=color_custom_input;
       end
   end
   
   figure(current_plot);
   hold all
   if avg_chans==1

       if use_days==1
           user_days=length(days_input);
           day_axis=[1:1:user_days];
           if use_plot_offset ==1
               day_axis=day_axis+plot_offset_input;
           end
           averaged_data=zeros(1,user_days);
           error_vector=zeros(1,user_days);
           for day=1:user_days
               %day_chan_data=zeros(1,length(chan_map));
               %extract day data
               for chan=1:chan_num
                    day_chan_data(day,chan)=handles.data{1,days_input(1,day)}{chan_map(1,chan),1}(dif_loc,4);
                    scatter_xdata(day,chan)=day;
               end
               averaged_data(1,day)=mean(day_chan_data(day,:));
               error_vector(1,day)=std(day_chan_data(day,:));
           end
       else
           day_axis=[1:1:days];
           if use_plot_offset ==1
               day_axis=day_axis+plot_offset_input;
           end
           averaged_data=zeros(1,days);
           error_vector=zeros(1,days);
           for day=1:days
               day_chan_data=zeros(1,length(chan_map));
               %extract day data
               for chan=1:chan_num
                    day_chan_data(day,chan)=handles.data{1,day}{chan_map(1,chan),1}(dif_loc,4);
                    scatter_xdata(day,chan)=day;
               end
               if use_avgimplog==1
                   averaged_data(1,day)=log(mean(day_chan_data(day,:)));
                   error_vector(1,day)=std(day_chan_data(day,:));%Correct this...
               else
                   averaged_data(1,day)=mean(day_chan_data(day,:));
                   error_vector(1,day)=std(day_chan_data(day,:));
               end
           end
       end
       
   if strcmp(plot_options,'scatter')==1
       errorbar(day_axis,averaged_data,error_vector,'-o','Color',plot_color)
       set(current_plot.Children,'XTick',day_axis)
       set(current_plot.Children,'XTickLabel',day_axis_label)
   elseif strcmp(plot_options,'lined')==1

   elseif strcmp(plot_options,'bar')==1
       bar(day_axis,averaged_data,'MarkerFaceColor',plot_color)
       errorbar(day_axis,averaged_data,error_vector,'-o','Color',plot_color)
       set(current_plot.Children,'XTick',day_axis)
       set(current_plot.Children,'XTickLabel',day_axis_label)
   end
       
       
   else
       if use_chans==1
          
          for chan = 1:chan_num
              if use_freq==1
                  scatter(handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(frequency_input),2),handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(frequency_input),3),1)
              else
                  scatter(handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(maxfreqrange),2),handles.data{1,selected_day}{chan_map(1,chan),1}(str2num(maxfreqrange),3),1)
              end
          end


       end
   end
   if show_scatter==1
   %calculate channel colors based off of parabolic equations
   value_step=1/(chan_num);
   color_eqn_vals=[0:value_step:1];
   for i=1:length(color_eqn_vals)
      %define red
      color_code(i,3)=color_eqn_vals(1,i)^2;
      %define green
      color_code(i,2)=-(color_eqn_vals(1,i)^2)+1;
      %define blue
      color_code(i,1)=-(4*color_eqn_vals(1,i)^2)+(4*(color_eqn_vals(1,i)));
   end


   for chan=1:chan_num
       scatter(scatter_xdata(:,chan),day_chan_data(:,chan),'filled','MarkerFaceColor',color_code(chan,:))
   end

   end
   if use_labels==1
        xlabel(xaxis_input_impmag)
        ylabel(yaxis_input_impmag)
        title(plottitle_input_impmag)
   end
end

if plot2==1
    
end

if plot3==1
    
end
    
    
    
end



guidata(hObject, handles);


% --- Executes on button press in use_fullfreq.
function use_fullfreq_Callback(hObject, eventdata, handles)
% hObject    handle to use_fullfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of use_fullfreq



function frequency_input_Callback(hObject, eventdata, handles)
% hObject    handle to frequency_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frequency_input as text
%        str2double(get(hObject,'String')) returns contents of frequency_input as a double


% --- Executes during object creation, after setting all properties.
function frequency_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frequency_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xaxis_input_zz_Callback(hObject, eventdata, handles)
% hObject    handle to xaxis_input_zz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xaxis_input_zz as text
%        str2double(get(hObject,'String')) returns contents of xaxis_input_zz as a double


% --- Executes during object creation, after setting all properties.
function xaxis_input_zz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xaxis_input_zz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yaxis_input_zz_Callback(hObject, eventdata, handles)
% hObject    handle to yaxis_input_zz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yaxis_input_zz as text
%        str2double(get(hObject,'String')) returns contents of yaxis_input_zz as a double


% --- Executes during object creation, after setting all properties.
function yaxis_input_zz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yaxis_input_zz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plottitle_input_zz_Callback(hObject, eventdata, handles)
% hObject    handle to plottitle_input_zz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plottitle_input_zz as text
%        str2double(get(hObject,'String')) returns contents of plottitle_input_zz as a double


% --- Executes during object creation, after setting all properties.
function plottitle_input_zz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plottitle_input_zz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in use_labels.
function use_labels_Callback(hObject, eventdata, handles)
% hObject    handle to use_labels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of use_labels



function xaxis_input_imp_Callback(hObject, eventdata, handles)
% hObject    handle to xaxis_input_imp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xaxis_input_imp as text
%        str2double(get(hObject,'String')) returns contents of xaxis_input_imp as a double


% --- Executes during object creation, after setting all properties.
function xaxis_input_imp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xaxis_input_imp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yaxis_input_imp_Callback(hObject, eventdata, handles)
% hObject    handle to yaxis_input_imp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yaxis_input_imp as text
%        str2double(get(hObject,'String')) returns contents of yaxis_input_imp as a double


% --- Executes during object creation, after setting all properties.
function yaxis_input_imp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yaxis_input_imp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plottitle_input_imp_Callback(hObject, eventdata, handles)
% hObject    handle to plottitle_input_imp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plottitle_input_imp as text
%        str2double(get(hObject,'String')) returns contents of plottitle_input_imp as a double


% --- Executes during object creation, after setting all properties.
function plottitle_input_imp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plottitle_input_imp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xaxis_input_ph_Callback(hObject, eventdata, handles)
% hObject    handle to xaxis_input_ph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xaxis_input_ph as text
%        str2double(get(hObject,'String')) returns contents of xaxis_input_ph as a double


% --- Executes during object creation, after setting all properties.
function xaxis_input_ph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xaxis_input_ph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yaxis_input_ph_Callback(hObject, eventdata, handles)
% hObject    handle to yaxis_input_ph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yaxis_input_ph as text
%        str2double(get(hObject,'String')) returns contents of yaxis_input_ph as a double


% --- Executes during object creation, after setting all properties.
function yaxis_input_ph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yaxis_input_ph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plottitle_input_ph_Callback(hObject, eventdata, handles)
% hObject    handle to plottitle_input_ph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plottitle_input_ph as text
%        str2double(get(hObject,'String')) returns contents of plottitle_input_ph as a double


% --- Executes during object creation, after setting all properties.
function plottitle_input_ph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plottitle_input_ph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in equal_title.
function equal_title_Callback(hObject, eventdata, handles)
% hObject    handle to equal_title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
title_string=get(handles.equal_title_input,'String');

set(handles.plottitle_input_zz,'String',title_string);
set(handles.plottitle_input_imp,'String',title_string);
set(handles.plottitle_input_ph,'String',title_string);
set(handles.plottitle_input_avgimp,'String',title_string);


function equal_title_input_Callback(hObject, eventdata, handles)
% hObject    handle to equal_title_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of equal_title_input as text
%        str2double(get(hObject,'String')) returns contents of equal_title_input as a double


% --- Executes during object creation, after setting all properties.
function equal_title_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to equal_title_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in use_freq.
function use_freq_Callback(hObject, eventdata, handles)
% hObject    handle to use_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of use_freq


% --- Executes on selection change in freq_list.
function freq_list_Callback(hObject, eventdata, handles)
% hObject    handle to freq_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns freq_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from freq_list


% --- Executes during object creation, after setting all properties.
function freq_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in use_chans.
function use_chans_Callback(hObject, eventdata, handles)
% hObject    handle to use_chans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of use_chans


% --- Executes on button press in use_days.
function use_days_Callback(hObject, eventdata, handles)
% hObject    handle to use_days (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of use_days


% --- Executes on button press in avg_chans.
function avg_chans_Callback(hObject, eventdata, handles)
% hObject    handle to avg_chans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of avg_chans



function avg_freq_Callback(hObject, eventdata, handles)
% hObject    handle to avg_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of avg_freq as text
%        str2double(get(hObject,'String')) returns contents of avg_freq as a double
avg_freq_input=str2num(get(hObject,'String'));
freq_vector=handles.data{1,1}{1,1}(:,1);
freq_difference=abs(freq_vector-avg_freq_input);
[dif_mag,dif_loc]=min(freq_difference);
nearest_freq=num2str(freq_vector(dif_loc));
handles.user_frequency_location=dif_loc;
update_string=sprintf('Closest Freq: %s',nearest_freq);
set(handles.freq_display,'string',update_string);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function avg_freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to avg_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot4.
function plot4_Callback(hObject, eventdata, handles)
% hObject    handle to plot4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot4



function xaxis_input_avgimp_Callback(hObject, eventdata, handles)
% hObject    handle to xaxis_input_avgimp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xaxis_input_avgimp as text
%        str2double(get(hObject,'String')) returns contents of xaxis_input_avgimp as a double


% --- Executes during object creation, after setting all properties.
function xaxis_input_avgimp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xaxis_input_avgimp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yaxis_input_avgimp_Callback(hObject, eventdata, handles)
% hObject    handle to yaxis_input_avgimp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yaxis_input_avgimp as text
%        str2double(get(hObject,'String')) returns contents of yaxis_input_avgimp as a double


% --- Executes during object creation, after setting all properties.
function yaxis_input_avgimp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yaxis_input_avgimp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plottitle_input_avgimp_Callback(hObject, eventdata, handles)
% hObject    handle to plottitle_input_avgimp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plottitle_input_avgimp as text
%        str2double(get(hObject,'String')) returns contents of plottitle_input_avgimp as a double


% --- Executes during object creation, after setting all properties.
function plottitle_input_avgimp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plottitle_input_avgimp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in data_scatter.
function data_scatter_Callback(hObject, eventdata, handles)
% hObject    handle to data_scatter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data_scatter



function color_custom_input_Callback(hObject, eventdata, handles)
% hObject    handle to color_custom_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of color_custom_input as text
%        str2double(get(hObject,'String')) returns contents of color_custom_input as a double


% --- Executes during object creation, after setting all properties.
function color_custom_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to color_custom_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in use_plotcolor.
function use_plotcolor_Callback(hObject, eventdata, handles)
% hObject    handle to use_plotcolor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of use_plotcolor



function plot_offset_input_Callback(hObject, eventdata, handles)
% hObject    handle to plot_offset_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plot_offset_input as text
%        str2double(get(hObject,'String')) returns contents of plot_offset_input as a double


% --- Executes during object creation, after setting all properties.
function plot_offset_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_offset_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in use_plot_offset.
function use_plot_offset_Callback(hObject, eventdata, handles)
% hObject    handle to use_plot_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of use_plot_offset


% --- Executes on button press in use_avgimplog.
function use_avgimplog_Callback(hObject, eventdata, handles)
% hObject    handle to use_avgimplog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of use_avgimplog


% --- Executes on button press in daily_plotter.
function daily_plotter_Callback(hObject, eventdata, handles)
% hObject    handle to daily_plotter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of daily_plotter


%%Someone else's function I found on a forum....
function strnumnew=addvilgole2(num)
if isnumeric(num)==1
    strnum=num2str(num);
    strnum2=regexprep(fliplr(strnum),' ','');
else
    if ischar(num)==1
        if sum(ismember(num,','))==0
        strnum2=regexprep(fliplr(num),' ','');
        end
    end
end

if isempty(str2num(strnum2))==0

strnum3=[];
for i=1:size(strnum2,2)
    iv=logical(abs(double(logical(i-fix(i/3)*3))-1));
    if iv
        if i~=size(strnum2,2)
            strv=[strnum2(1,i) ','];
        else
            strv=strnum2(1,i);
        end
    else
        strv=strnum2(1,i);
    end

      strnum3=[strnum3 strv];
  end
  strnumnew=fliplr(strnum3);
  else
  strnumnew=num;    
  end
%end function
