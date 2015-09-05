function varargout = CostFunctionParameterGUI(varargin)
% COSTFUNCTIONPARAMETERGUI M-file for CostFunctionParameterGUI.fig
%      COSTFUNCTIONPARAMETERGUI, by itself, creates a new COSTFUNCTIONPARAMETERGUI or raises the existing
%      singleton*.
%
%      H = COSTFUNCTIONPARAMETERGUI returns the handle to a new COSTFUNCTIONPARAMETERGUI or the handle to
%      the existing singleton*.
%
%      COSTFUNCTIONPARAMETERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COSTFUNCTIONPARAMETERGUI.M with the given input arguments.
%
%      COSTFUNCTIONPARAMETERGUI('Property','Value',...) creates a new COSTFUNCTIONPARAMETERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CostFunctionParameterGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CostFunctionParameterGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CostFunctionParameterGUI

% Last Modified by GUIDE v2.5 07-May-2009 16:06:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CostFunctionParameterGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CostFunctionParameterGUI_OutputFcn, ...
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

% --- Executes just before CostFunctionParameterGUI is made visible.
function CostFunctionParameterGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CostFunctionParameterGUI (see VARARGIN)

% Choose default command line output for CostFunctionParameterGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% get initial values from AgentController{1}
agCont = evalin('base','env.Agents{1}.AgentController');
set(handles.editTargetAttraction,'String',...
   num2str(agCont.TargetAttraction));
set(handles.sliderTargetAttraction,'Value',...
   (agCont.TargetAttraction));
set(handles.editRegionExploration,'String',...
   num2str(agCont.RegionExploration));
set(handles.sliderRegionExploration,'Value',...
   (agCont.RegionExploration));
set(handles.editAgentRepulsion,'String',...
   num2str(agCont.AgentRepulsion));
set(handles.sliderAgentRepulsion,'Value',...
   (agCont.AgentRepulsion));
set(handles.editWaypointRepulsion,'String',...
   num2str(agCont.WaypointRepulsion));
set(handles.sliderWaypointRepulsion,'Value',...
   (agCont.WaypointRepulsion));
set(handles.editStateDeviation,'String',...
   num2str(agCont.StateDeviation));
set(handles.sliderStateDeviation,'Value',...
   (agCont.StateDeviation));
set(handles.editBaseMultiplier,'String',...
   num2str(agCont.BaseMultiplier));
set(handles.sliderBaseMultiplier,'Value',...
   (agCont.BaseMultiplier));

x=fieldnames(handles);
for i=1:length(x)
    if strncmp('slider',x{i},6)
        val = get(handles.(x{i}),'Value');
        set(handles.(x{i}),'Max',val*3);
        set(handles.(x{i}),'Min',0);
    end
end



% UIWAIT makes CostFunctionParameterGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CostFunctionParameterGUI_OutputFcn(hObject, eventdata, handles)
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
handles;


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

% delete(handles.figure1)



% --- Executes on slider movement.
function sliderTargetAttraction_Callback(hObject, eventdata, handles)
% hObject    handle to sliderTargetAttraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
setGain('TargetAttraction',get(hObject,'Value'));
set(handles.editTargetAttraction,'String',...
   num2str(get(hObject,'Value')));

% --- Executes during object creation, after setting all properties.
function sliderTargetAttraction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderTargetAttraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderRegionExploration_Callback(hObject, eventdata, handles)
% hObject    handle to sliderRegionExploration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
setGain('RegionExploration',get(hObject,'Value'));
set(handles.editRegionExploration,'String',...
   num2str(get(hObject,'Value')));


% --- Executes during object creation, after setting all properties.
function sliderRegionExploration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderRegionExploration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderAgentRepulsion_Callback(hObject, eventdata, handles)
% hObject    handle to sliderAgentRepulsion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
setGain('AgentRepulsion',get(hObject,'Value'));
set(handles.editAgentRepulsion,'String',...
   num2str(get(hObject,'Value')));


% --- Executes during object creation, after setting all properties.
function sliderAgentRepulsion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderAgentRepulsion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderStateDeviation_Callback(hObject, eventdata, handles)
% hObject    handle to sliderStateDeviation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
setGain('StateDeviation',get(hObject,'Value'));
set(handles.editStateDeviation,'String',...
   num2str(get(hObject,'Value')));


% --- Executes during object creation, after setting all properties.
function sliderStateDeviation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderStateDeviation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editTargetAttraction_Callback(hObject, eventdata, handles)
% hObject    handle to editTargetAttraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTargetAttraction as text
%        str2double(get(hObject,'String')) returns contents of editTargetAttraction as a double
setGain('TargetAttraction',get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function editTargetAttraction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTargetAttraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRegionExploration_Callback(hObject, eventdata, handles)
% hObject    handle to editRegionExploration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRegionExploration as text
%        str2double(get(hObject,'String')) returns contents of editRegionExploration as a double
setGain('RegionExploration',get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function editRegionExploration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRegionExploration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAgentRepulsion_Callback(hObject, eventdata, handles)
% hObject    handle to editAgentRepulsion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAgentRepulsion as text
%        str2double(get(hObject,'String')) returns contents of editAgentRepulsion as a double
setGain('AgentRepulsion',get(hObject,'Value'))


% --- Executes during object creation, after setting all properties.
function editAgentRepulsion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAgentRepulsion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editStateDeviation_Callback(hObject, eventdata, handles)
% hObject    handle to editStateDeviation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStateDeviation as text
%        str2double(get(hObject,'String')) returns contents of editStateDeviation as a double
setGain('StateDeviation',get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function editStateDeviation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editStateDeviation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin('base','notify(env,''startSimulation'')');

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin('base','notify(env,''stopSimulation'')');


% --- Executes on slider movement.
function sliderWaypointRepulsion_Callback(hObject, eventdata, handles)
% hObject    handle to sliderWaypointRepulsion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
setGain('WaypointRepulsion',get(hObject,'Value'))
set(handles.editWaypointRepulsion,'String',...
   num2str(get(hObject,'Value')));


% --- Executes during object creation, after setting all properties.
function sliderWaypointRepulsion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderWaypointRepulsion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editWaypointRepulsion_Callback(hObject, eventdata, handles)
% hObject    handle to editWaypointRepulsion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editWaypointRepulsion as text
%        str2double(get(hObject,'String')) returns contents of editWaypointRepulsion as a double
setGain('WaypointRepulsion',get(hObject,'Value'))


% --- Executes during object creation, after setting all properties.
function editWaypointRepulsion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editWaypointRepulsion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function sliderBaseMultiplier_Callback(hObject, eventdata, handles)
% hObject    handle to sliderBaseMultiplier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
setGain('BaseMultiplier',get(hObject,'Value'))
set(handles.editBaseMultiplier,'String',...
   num2str(get(hObject,'Value')));


% --- Executes during object creation, after setting all properties.
function sliderBaseMultiplier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderBaseMultiplier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editBaseMultiplier_Callback(hObject, eventdata, handles)
% hObject    handle to editBaseMultiplier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBaseMultiplier as text
%        str2double(get(hObject,'String')) returns contents of editBaseMultiplier as a double
setGain('BaseMultiplier',get(hObject,'Value'))


% --- Executes during object creation, after setting all properties.
function editBaseMultiplier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBaseMultiplier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function setGain(property,value)
for i=1:evalin('base','length(env.Agents)')
    evalin('base',['env.Agents{',num2str(i),'}.AgentController.',property,'=',num2str(value)]);
end

