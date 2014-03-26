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

% Last Modified by GUIDE v2.5 27-Feb-2014 17:24:57

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
global TS T TMax TMin l_intf
if isempty(TS)==0
set(handles.TS,'Value',1)
end

if isempty(T)==0
set(handles.T,'Value',1)
end

if isempty(TMax)==0
set(handles.TMax,'Value',1)
end

if isempty(TMin)==0
set(handles.TMin,'Value',1)
end
if isempty(l_intf)==0
set(handles.l_intf,'Value',1)
end

set(handles.figure1,'Name','DETERMINATION OF OPTICAL CONSTANTS')


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





% --- Executes on button press in Import_TS.
function Import_TS_Callback(hObject, eventdata, handles)
% hObject    handle to Import_TS (see GCBO)
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


% --- Executes on button press in Import_T.
function Import_T_Callback(hObject, eventdata, handles)
% hObject    handle to Import_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save1=pwd;
global pathname1
if isempty(pathname1)==0
    cd(pathname1)
end  % to direct uigetfile to previously used pathname saved as pathname1

global filename pathname
[filename, pathname, filterindex] = uigetfile( ...
{  '*.xls','ASCII-files (*.xls)'});
cd(save1)
if filterindex~1 ;  %valid file is selected
    save=pwd;
cd(pathname)
global T
T=xlsread(filename);
cd (save)
[m,n] = size(T);
if m>1 & n==2
   set(handles.T,'Value',1)
else
    errordlg('Input is not proper, it should be a two column data','Bad Input','modal')
end
pathname1=pathname;
end


% --- Executes on button press in Plot_TS.
function Plot_TS_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_TS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TS    %  even if any data is not assigned to TS,
%               TS becomes an empty matrix by declaring it global
               
if isempty(TS)==0 
fig_TS=figure;
plot(TS(:,1),TS(:,2))
xlabel('Wavelength(nm)');ylabel('Substrate Transmittance (%)')
else
    errordlg('Data for Substrate Transmission is Unavailable','Data Unavailable','modal')
end

% --- Executes on button press in Plot_T.
function Plot_T_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global T
if isempty(T)==1 
    errordlg('Data for Sample Transmission is Unavailable','Data Unavailable','modal')
else
fig_T=figure;
plot(T(:,1),T(:,2))
xlabel('Wavelength(nm)');ylabel('Sample Transmittance (%)')
end



% --- Executes on button press in Plot_TS_T.
function Plot_TS_T_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_TS_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global T TS
if isempty(T)==1 & isempty(TS)==1
  errordlg('Data for both Substrate and Sample Transmission is Unavailable','Data Unavailable','modal')
elseif isempty(T)==1
    errordlg('Data for Sample Transmission is Unavailable','Data Unavailable','modal')
elseif isempty(TS)==1
    errordlg('Data for Substrate Transmission is Unavailable','Data Unavailable','modal')
else  
  fig_TS_and_T=figure;
plot(T(:,1),T(:,2))
hold on
plot(TS(:,1),TS(:,2),'r')
xlabel('Wavelength(nm)');ylabel('Transmittance (%)')
end
% --- Executes on button press in maxima.
function maxima_Callback(hObject, eventdata, handles)
% hObject    handle to maxima (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fig_get_maxima T

if isempty(T)==1
    errordlg('Transmission Spectrum is not available to Choose Maxima',...
        'Transmission Spectrum Unavailable','modal');
else
fig_get_maxima=figure;
    plot(T(:,1),T(:,2))
xlabel('Wavelength(nm)');ylabel('Sample Transmittance (%)')
sh = uicontrol(fig_get_maxima,'Style','pushbutton',...
               'Position',[350 50 100 30],...
               'String','Accept Maxima',...
               'Callback',@Accept_Maxima_callback);
     global p
p=handles.TMax;             
datacursormode on
end
function Accept_Maxima_callback(hObject,eventdata,handles)
global fig_get_maxima TMax
dcm_obj = datacursormode(fig_get_maxima);
c_info = getCursorInfo(dcm_obj);

if isempty(c_info)==1  %no data is selected
    errordlg('Select maxima of the transmission curve','Data point not selected','modal')
else
    TMax=get_selected_data(c_info)
close(fig_get_maxima)
global p
set(p,'Value',1)
end

function [B]=get_selected_data(A)
a={A.Position};
% n=length(A.Position)
n=numel(a);
for i=1:n
    
    B(i,1)=a{i}(1);
    B(i,2)=a{i}(2);
end
function minima_Callback(hObject, eventdata, handles)
% hObject    handle to minima (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fig_get_minima T
if isempty(T)==1
    errordlg('Transmission Spectrum is not available to Choose Minima',...
        'Transmission Spectrum Unavailable','modal');
else
fig_get_minima=figure;
plot(T(:,1),T(:,2))
xlabel('Wavelength(nm)');ylabel('Sample Transmittance (%)')
sh = uicontrol(fig_get_minima,'Style','pushbutton',...
               'Position',[350 50 100 30],...
               'String','Accept Minima',...
               'Callback',@Accept_Minima_callback);
global q
q=handles.TMin;             
                  
datacursormode on
end

function Accept_Minima_callback(hObject,eventdata)
global fig_get_minima TMin
dcm_obj = datacursormode(fig_get_minima);
c_info = getCursorInfo(dcm_obj);

if isempty(c_info)==1  %no data is selected
    errordlg('Select minima of the transmission curve','Data point not selected','modal')
else
    TMin=get_selected_data(c_info)
close(fig_get_minima)
global q
set(q,'Value',1)
end



% --- Executes on button press in extrema.
function extrema_Callback(hObject, eventdata, handles)
% hObject    handle to extrema (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig_get_FE T
if isempty(T)==1
    errordlg('Transmission Spectrum is not available to Choose First Extrema',...
        'Transmission Spectrum Unavailable','modal');
else
fig_get_FE=figure;
plot(T(:,1),T(:,2))
xlabel('Wavelength(nm)');ylabel('Sample Transmittance (%)')
sh = uicontrol(fig_get_FE,'Style','pushbutton',...
               'Position',[350 50 125 30],...
               'String','Accept First Extrema',...
               'Callback',@Accept_First_Extrema_callback);
global r
r=handles.l_intf;             
                  
datacursormode on
end

function Accept_First_Extrema_callback(hObject,eventdata)
global fig_get_FE l_intf
dcm_obj = datacursormode(fig_get_FE);
c_info = getCursorInfo(dcm_obj);

if isempty(c_info)==1  %no data is selected
    errordlg('Select first extrema of the fringes of transmission curve','Data point not selected','modal')
else
    FE=get_selected_data(c_info);
close(fig_get_FE)
global r
set(r,'Value',1)
l_intf1=FE(1);
l_intf=l_intf1-0.01
end

% --- Executes on button press in read_input.
function read_input_Callback(hObject, eventdata, handles)
% hObject    handle to read_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TS T TMax TMin l_intf
global filename pathname
save1=pwd;
global pathname1
if isempty(pathname1)==0
    cd(pathname1)
end  % to direct uigetfile to previously used pathname saved as pathname1

[filename, pathname, filterindex] = uigetfile( ...
{  '*.xls','Excel-files (*.xls)'});
cd(save1)
if filterindex~0;   %some file is selected
[pathstr, name, ext, versn] = fileparts(filename);

save=pwd;
cd(pathname)

[type,sheetname] = xlsfinfo(name);

a=sum( strcmp('TS',sheetname));b=sum( strcmp('T',sheetname));
c=sum( strcmp('TMax',sheetname));d=sum( strcmp('TMin',sheetname));
e=sum( strcmp('TS',sheetname));
    
if [a b c d e]==[1 1 1 1 1]    
TS=xlsread(name,'TS');
T=xlsread(name,'T');
TMax=xlsread(name,'TMax')
TMin=xlsread(name,'TMin')
l_intf=xlsread(name,'l_intf')
[m1,n1] = size(TS);[m2,n2] = size(T);[m3,n3] = size(TMax);
[m4,n4] = size(TMax);[m5,n5] = size(l_intf);

if m1>1 & n1==2 & m2>1 & n2==2 & m3>1 & n3==2 & m4>1 & n4==2 & m5==1 & n5==1 
set(handles.input,'Value',1)
else
    errordlg('Input sheets data mismatch with the required one','Bad Input','modal')
end

else
errordlg('Any or all of sheets named TS,T, TMax, TMin,l_intf is unavailable in the input excel file','Bad Input','modal')
end

cd (save)
pathname1=pathname;
end

end



function I_min_Callback(hObject, eventdata, handles)
% hObject    handle to I_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of I_min as text
%        str2double(get(hObject,'String')) returns contents of I_min as a double

global l_min
previous_l_min=l_min;
l_min= str2double(get(hObject,'String'));
if isnan(l_min) || l_min<=0
	errordlg('You must enter a positive numeric value','Bad Input','modal')
	set(hObject,'String',previous_l_min);
    l_min=previous_l_min;
    return
else
    set(hObject,'String',l_min);

end


% --- Executes during object creation, after setting all properties.
function I_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to I_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

global l_min
l_min=300;
set(hObject,'String',l_min);

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function I_max_Callback(hObject, eventdata, handles)
% hObject    handle to I_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global l_max
previous_l_max=l_max;
l_max= str2double(get(hObject,'String'));
if isnan(l_max) || l_max<=0
	errordlg('You must enter a positive numeric value','Bad Input','modal')
	set(hObject,'String',previous_l_max);
    l_max=previous_l_max;
    return
else
    set(hObject,'String',l_max);

end


% Hints: get(hObject,'String') returns contents of I_max as text
%        str2double(get(hObject,'String')) returns contents of I_max as a double


% --- Executes during object creation, after setting all properties.
function I_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to I_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

global l_max
l_max=1000;
set(hObject,'String',l_max);



% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function I_step_Callback(hObject, eventdata, handles)
% hObject    handle to I_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of I_step as text
%        str2double(get(hObject,'String')) returns contents of I_step as a double

global l_step
previous_l_step=l_step;
l_step= str2double(get(hObject,'String'));
if isnan(l_step) || l_step<=0
	errordlg('You must enter a positive numeric value','Bad Input','modal')
	set(hObject,'String',previous_l_step);
    l_step=previous_l_step;
    return
else
    set(hObject,'String',l_step);
end



% --- Executes during object creation, after setting all properties.
function I_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to I_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

global l_step
l_step=1;
set(hObject,'String',l_step);



% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in choose_coating.
function choose_coating_Callback(hObject, eventdata, handles)
% hObject    handle to choose_coating (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns choose_coating contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choose_coating

global indicator
str = get(hObject, 'String');
val = get(hObject,'Value');
switch str{val}
    case 'Normal Coating' % User selects Normal Coating.
            indicator=1;
         case 'Antireflection Coating' % User selects Antireflection Coating.
            indicator=-1;
         end
 


% --- Executes during object creation, after setting all properties.
function choose_coating_CreateFcn(hObject, eventdata, handles)
% hObject    handle to choose_coating (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject,'String',{'Normal Coating','Antireflection Coating'})
global indicator
indicator=1;
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_input.
function save_input_Callback(hObject, eventdata, handles)
% hObject    handle to save_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TS T TMax TMin l_intf
global filename pathname
if isempty(TS)==1 || isempty(T)==1|| isempty(TMax)==1|| isempty(TMin)==1|| isempty(l_intf)==1
  errordlg('All or some inputs are not available to be saved','Input Unavailable','modal')
else
[pathstr, name, ext, versn] = fileparts(filename);

name=sprintf('%s%s',name,'_expt');
print_result_xls({TS T TMax TMin l_intf;...
    'TS' 'T' 'TMax' 'TMin' 'l_intf'},name,pathname)
save=pwd;
cd(pathname)
name=sprintf('%s%s',name,'.xls');
winopen(name);
cd( save)
end


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TS T TMax TMin l_intf
global d R K ALPHA CR B A
global l_min l_max l_step indicator
if isempty(TS)==1||isempty(T)==1||isempty(TMax)==1||isempty(TMin)==1||isempty(l_intf)==1
    errordlg('Proper Input is not available to run the program')
else
fig2=figure;
[d, R,K,ALPHA,CR,B,A]=main_swanepol(TS,T, TMax,TMin,l_intf,...
    l_min,l_max,l_step,indicator);

r=CR(1)+CR(2)/((550).^2);
d = floor(d*10)/10 ; %to take upto 1 digit beyong integer
r = floor(r*100)/100;  %to take upto 2 digit beyong integer


Thickness_string=sprintf('%s %d %s','Thickness=',d,'nm');
Ref_string=sprintf('%s%d','n at 550 nm=', r);
set(handles.Print_Summary_Result,'String',{Thickness_string;Ref_string});
end



% --- Executes on button press in save_result.
function save_result_Callback(hObject, eventdata, handles)
% hObject    handle to save_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global d R K ALPHA CR B A
global filename pathname
if isempty(d)==1 || isempty(R)==1|| isempty(K)==1
  errordlg('Result is not available to be saved','Result Unavailable','modal')
else

[pathstr, name, ext, versn] = fileparts(filename);
name=sprintf('%s%s',name,'_simulated');
print_result_xls({d R K ALPHA CR B A;...
    'Thickness' 'Refractive Index' 'Attenuation Coefficient'...
    'Absorption Coefficient' 'CR' 'B' 'A'},name,pathname)
save=pwd;
cd(pathname)
name=sprintf('%s%s',name,'.xls');
winopen(name);
cd( save)

end


% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.


% --- Executes on button press in cal_dbg.
function cal_dbg_Callback(hObject, eventdata, handles)
% hObject    handle to cal_dbg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ALPHA
if isempty(ALPHA)==1
    errordlg('Data for Absorption coefficient is not available to Calculate band gap',...
        'Absorption Coefficient Unavailable','modal');
else
% plotting alpha_h_nu^2 vs h_nu graph
    h=6.626*10^-34;
c=3*10^8;
imax=numel(ALPHA(:,1));

for i=1:imax
    l=ALPHA(i,1);
    alpha=ALPHA(i,2);

l=l*10^-9;          % to convert wavelength in meter 
alpha=alpha*10^9; % to convert alpha in m^-1 from nm^-1

h_nu=(h*c/l)*0.625*10^19; % to convert energy in ev from Joule
B(i,1)=h_nu;

alpha_h_nu=(alpha*h_nu)^2;     % in the unit of ev^2*m^-2
B(i,2)=alpha_h_nu;
end

global fig_get_range
fig_get_range=figure;
plot(B(:,1),B(:,2))
xlabel('h\nu in ev')
ylabel('(\alpha h\nu)^2 in ev^2*m^-2')

sh = uicontrol(fig_get_range,'Style','pushbutton',...
               'Position',[350 50 100 30],...
               'String','Accept Range',...
               'Callback',@Accept_Range_callback);
 global para
 para=handles.Print_Direct_Bandgap; % an extra handle is created and passed
 % to Accept_Range_callback as a parameter para
 
datacursormode on
end

function Accept_Range_callback(hObject,eventdata,handles)
global fig_get_range 
dcm_obj = datacursormode(fig_get_range);
c_info = getCursorInfo(dcm_obj);

if isempty(c_info)==1  %no data is selected
    errordlg('Data point not selected','modal')
else
    Range=get_selected_data(c_info);  % get_selected_data is a function already written under some other function
close(fig_get_range)

end

global ALPHA Eg
p1=min(Range(:,1));
p2=max(Range(:,1));
fig_direct_bandgap=figure;
[Eg,W,B]=direct_band_gap(ALPHA,p1,p2);

Eg = floor(Eg*1000)/1000;  %to take upto 2 digit beyong integer


dbg_string=sprintf('%s %d %s','Direct Bandgap=',Eg,'ev');
global para
set(para,'String',dbg_string);



% --- Executes on button press in cal_idbg.
function cal_idbg_Callback(hObject, eventdata, handles)
% hObject    handle to cal_idbg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ALPHA
if isempty(ALPHA)==1
    errordlg('Data for Absorption coefficient is not available to Calculate band gap',...
        'Absorption Coefficient Unavailable','modal');
else
% plotting alpha_h_nu^2 vs h_nu graph
    h=6.626*10^-34;
c=3*10^8;
imax=numel(ALPHA(:,1));

for i=1:imax
    l=ALPHA(i,1);
    alpha=ALPHA(i,2);

l=l*10^-9;          % to convert wavelength in meter 
alpha=alpha*10^9; % to convert alpha in m^-1 from nm^-1

h_nu=(h*c/l)*0.625*10^19; % to convert energy in ev from Joule
B(i,1)=h_nu;

alpha_h_nu=(alpha*h_nu)^(1/2);     % in the unit of ev^2*m^-2
B(i,2)=alpha_h_nu;
end

global fig_get_range1
fig_get_range1=figure;
plot(B(:,1),B(:,2))
xlabel('h\nu in ev')
ylabel('(\alpha h\nu)^(1/2) in ev^(1/2)*m^-(1/2)')

sh = uicontrol(fig_get_range1,'Style','pushbutton',...
               'Position',[350 50 100 30],...
               'String','Accept Range1',...
               'Callback',@Accept_Range1_callback);
     global para1
     para1=handles.Print_Indirect_Bandgap;
datacursormode on
end

function Accept_Range1_callback(hObject,eventdata,handles)
global fig_get_range1 
dcm_obj = datacursormode(fig_get_range1);
c_info = getCursorInfo(dcm_obj);

if isempty(c_info)==1  %no data is selected
    errordlg('Data point not selected','modal')
else
    Range=get_selected_data(c_info);  % get_selected_data is a function already written under some other function
close(fig_get_range1)

end

global ALPHA Eg1
p1=min(Range(:,1));
p2=max(Range(:,1));
fig_indirect_bandgap=figure;
[Eg1,W,B]=indirect_band_gap(ALPHA,p1,p2);

Eg1 = floor(Eg1*1000)/1000;  %to take upto 2 digit beyong integer


indbg_string=sprintf('%s %d %s','Indirect Bandgap=',Eg1,'ev');
global para1
set(para1,'String',indbg_string);




% --- Executes on button press in save_dbg.
function save_dbg_Callback(hObject, eventdata, handles)
% hObject    handle to save_dbg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Eg
global filename pathname
if isempty(Eg)==1 
    errordlg('Result is not available to be saved','Result Unavailable','modal')
else

[pathstr, name, ext, versn] = fileparts(filename);
name=sprintf('%s%s',name,'_simulated');
print_result_xls({Eg;...
    'Direct Bandgap'},name,pathname)
save=pwd;
cd(pathname)
name=sprintf('%s%s',name,'.xls');
winopen(name);
cd( save)

end


% --- Executes on button press in save_indbg.
function save_indbg_Callback(hObject, eventdata, handles)
% hObject    handle to save_indbg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Eg1
global filename pathname
if isempty(Eg1)==1 
    errordlg('Result is not available to be saved','Result Unavailable','modal')
else

[pathstr, name, ext, versn] = fileparts(filename);
name=sprintf('%s%s',name,'_simulated');
print_result_xls({Eg1;...
    'Indirect Bandgap'},name,pathname)
save=pwd;
cd(pathname)
name=sprintf('%s%s',name,'.xls');
winopen(name);
cd( save)

end



% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear global TS T TMax TMin l_intf d R K ALPHA Eg Eg1
set(handles.TS,'Value',0)
set(handles.T,'Value',0)
set(handles.TMax,'Value',0)
set(handles.TMin,'Value',0)
set(handles.l_intf,'Value',0)
set(handles.input,'Value',0)
set(handles.Print_Summary_Result,'String',{});
set(handles.Print_Direct_Bandgap,'String',{});
set(handles.Print_Indirect_Bandgap,'String',{});








% --- Executes on button press in minima.



