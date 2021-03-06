function varargout = gui(varargin)
% GUI M-file for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 13-Apr-2014 15:40:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui

set(handles.figure1,'Name','Design and simulation of optical filter')
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in import_mat_file_1.
function import_mat_file_1_Callback(hObject, eventdata, handles)
% hObject    handle to import_mat_file_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

save1=pwd;
global pathname1
if isempty(pathname1)==0
    cd(pathname1)
end  % to direct uigetfile to previously used pathname saved as pathname1


   [filename, pathname, filterindex] = uigetfile( ...
{  '*.xls','ASCII-files (*.xls)'});
cd(save1)

if filterindex~1;   %some file is selected
    [pathstr, name, ext] = fileparts(filename);
save=pwd;
cd(pathname)
global file1 n1 alpha_1
n1=xlsread(name,'Refractive Index');
alpha_1=xlsread(name,'Absorption Coefficient');
cd (save)
[a1,b1] = size(n1);
[a2,b2] = size(alpha_1);
if a1>1 && b1==2 && a2>1 && b2==2
set(handles.file1,'Value',1)
else
    errordlg('Input is not proper, it should be a two column data','Bad Input','modal')
end
pathname1=pathname;
end;





% --- Executes on button press in import_mat_file_2.
function import_mat_file_2_Callback(hObject, eventdata, handles)
% hObject    handle to import_mat_file_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

save1=pwd;
global pathname1
if isempty(pathname1)==0
    cd(pathname1)
end  % to direct uigetfile to previously used pathname saved as pathname1


   [filename, pathname, filterindex] = uigetfile( ...
{  '*.xls','ASCII-files (*.xls)'});
cd(save1)

if filterindex~1;   %some file is selected
    [pathstr, name, ext] = fileparts(filename);
save=pwd;
cd(pathname)
global file2 n2 alpha_2
n2=xlsread(name,'Refractive Index');
alpha_2=xlsread(name,'Absorption Coefficient');
cd (save)
[c1,d1] = size(n2);
[c2,d2] = size(alpha_2);
if c1>1 && d1==2 && c2>1 && d2==2
set(handles.file2,'Value',1)
else
    errordlg('Input is not proper, it should be a two column data','Bad Input','modal')
end
pathname1=pathname;
end;




% --- Executes on button press in import_ts_file.
function import_ts_file_Callback(hObject, eventdata, handles)
% hObject    handle to import_ts_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save1=pwd;
global pathname1
if isempty(pathname1)==0
    cd(pathname1)
end  % to direct uigetfile to previously used pathname saved as pathname1


   [filename, pathname, filterindex] = uigetfile( ...
{  '*.xls','ASCII-files (*.xls)'});
cd(save1)

if filterindex~1;   %some file is selected
save=pwd;
cd(pathname)
global TS
TS=xlsread(filename);
cd (save)
[m,n] = size(TS);
if m>1 & n==2
set(handles.TS,'Value',1)
else
    errordlg('Input is not proper, it should be a two column data','Bad Input','modal')
end
pathname1=pathname;
end



% --- Executes on button press in TS.
function TS_Callback(hObject, eventdata, handles)
% hObject    handle to TS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TS


% --- Executes during object creation, after setting all properties.
function lambda_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambda_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global lambda
lambda=550;
set(hObject,'String',lambda);



% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function import_mat_file_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to import_mat_file_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function import_mat_file_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to import_mat_file_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function import_ts_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to import_ts_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function reflectivity_edit_Callback(hObject, eventdata, handles)
% hObject    handle to reflectivity_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ref
previous_ref=ref;
ref= str2double(get(hObject,'String'));
if isnan(ref) || ref<0 || ref>100
	errordlg('You must enter a positive numeric value(0-100)','Bad Input','modal')
	set(hObject,'String',previous_ref);
    ref=previous_ref;
    return
else
    set(hObject,'String',ref);

end


% Hints: get(hObject,'String') returns contents of reflectivity_edit as text
%        str2double(get(hObject,'String')) returns contents of reflectivity_edit as a double


% --- Executes during object creation, after setting all properties.
function reflectivity_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reflectivity_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global ref
ref=0;
set(hObject,'String',ref);


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global n1 n2 TS alpha_1 alpha_2
global lambda ref
if isempty(TS)==1||isempty(n1)==1||isempty(n2)==1||isempty(alpha_1)==1||isempty(alpha_2)==1
    errordlg('Proper Input is not available to run the program')
else

[widths,R_final]=high_ref_coating(lambda,ref,n1,alpha_1,TS,n2,alpha_2);

size=numel(widths);
no_high_layers=size/2+1;
no_low_layers=size/2-1;


layers_string1=sprintf('%s %d' ,'No. of high_ref layers=',no_high_layers);
layers_string2=sprintf('%s %d','No. of low_ref layers=',no_low_layers);
width_string1=sprintf('%s %d','Width of high_ref layers=',widths(1));
width_string2=sprintf('%s %d','Width of low_ref layers=',widths(2));

set(handles.summary,'String',{layers_string1;layers_string2;width_string1;width_string2});
end



% --- Executes on button press in display_graph.
function display_graph_Callback(hObject, eventdata, handles)
% hObject    handle to display_graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global R_final
if isempty(TS)==1 & isempty(n1)==1 & isempty(n2)==1 & isempty(alpha_1)==1 & isempty(alpha_2)==1 
  errordlg('Files for both material 1 and material 2 and substrate transmission are Unavailable','Data Unavailable','modal')
elseif isempty(TS)==1
    errordlg('Data for Substrate Transmission is Unavailable','Data Unavailable','modal')
elseif isempty(n1)==1 & isempty(alpha_1)==1 
    errordlg('File for material 1 is Unavailable','Data Unavailable','modal')
elseif isempty(n2)==1 & isempty(alpha_2)==1 
    errordlg('File for material 2 is Unavailable','Data Unavailable','modal')
    elseif isempty(n2)==1 & isempty(alpha_2)==1 
    errordlg('File for material 2 is Unavailable','Data Unavailable','modal')
    elseif isempty(R_final)==1 
    errordlg('some unexpected error try again','sorry','modal')
else  
  fig_ref_lambda=figure;
plot(R_final(:,1),R_final(:,2))
xlabel('Wavelength(nm)');ylabel('Reflectance(%)')
end




function lambda_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lambda_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lambda_edit as text
%        str2double(get(hObject,'String')) returns contents of lambda_edit as a double
global lambda
previous_lambda=lambda;
lambda= str2double(get(hObject,'String'));
if isnan(lambda) || lambda<=0
	errordlg('You must enter a positive numeric value','Bad Input','modal')
	set(hObject,'String',previous_lambda);
    lambda=previous_lambda;
    return
else
    set(hObject,'String',lambda);

end



% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear global TS n1 n2  alpha_1 alpha_2
set(handles.TS,'Value',0)
set(handles.file1,'Value',0)
set(handles.file2,'Value',0)
set(handles.summary,'String',{});




% --- Executes on button press in file1.
function file1_Callback(hObject, eventdata, handles)
% hObject    handle to file1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of file1


% --- Executes on button press in file2.
function file2_Callback(hObject, eventdata, handles)
% hObject    handle to file2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of file2


