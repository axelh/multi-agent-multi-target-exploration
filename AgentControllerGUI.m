%   Created by Axel Hackbarth, UC Berkeley VDL / TU-Harburg MuM

classdef AgentControllerGUI < SimulationObject
%     %AGENTCONTROLLERGUI Summary of this class goes here
%     %   Detailed explanation goes here
    properties
        Handle;
        GUIcomponents
    end
    
    properties (Access=private)
        callback;
    end
    
    methods
        function this = AgentControllerGUI(varargin)
            this.Handle = figure;
            this.callback = @myCallbackMethod;
            this.GUIcomponents{end+1} = uicontrol('Style','slider','Callback', ...
                {@(src, event)myCallbackMethod(this, src, event)});
        end
        
        function addSlider(this, name, min, max, callback)
            this.callback = @myCallbackMethod;
            this.GUIcomponents{end+1} = uicontrol('Style','slider',name, ...
                {@(src, event)myCallbackMethod(this, src, event)});
        end
        
        function newTimeStep(this)
            
        end
    end
    
    methods (Access = private)
        function myCallbackMethod(this, src, event)
            disp(get(src,'value'));
        end
    end
end

%     
%     properties
%         GUIHandle
%         UIControls
%     end
%     
%     methods
%         function this = AgentControllerGUI(varargin)
%             this.GUIHandle = figure;
%             this.UIControls{end+1} = uicontrol(...
%                 'Style','slider','String','slider1',...
%                 'Position',[50 10 200 20]);
%         end
%         
%         function newTimeStep(this)
%             
%         end
%         
%     end
%     
% end
% 
% 
%         % --- Executes on slider movement.
%         function slider1__Callback(hObject, eventdata, handles)
%         % hObject    handle to sliderExploration (see GCBO)
%         % eventdata  reserved - to be defined in a future version of MATLAB
%         % handles    structure with handles and user data (see GUIDATA)
% 
%         % Hints: get(hObject,'Value') returns position of slider
%         %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%         disp('test');
%         end


% 
% function AgentControllerGUI__OpeningFcn(hObject, eventdata, handles, varargin)
% % This function has no output args, see OutputFcn.
% % hObject    handle to figure
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% % varargin   command line arguments to mygui (see VARARGIN)
% 
% % Choose default command line output for mygui
% handles.output = hObject;
% 
% % Update handles structure
% guidata(hObject, handles);
% 
% % UIWAIT makes mygui wait for user response (see UIRESUME)
% % uiwait(handles.mygui);






% % 
% % 
% % function varargout = AgentControllerGUI(varargin)
% % % COSTFUNCTIONPARAMETERGUI M-file for AgentControllerGUI.fig
% % %      COSTFUNCTIONPARAMETERGUI, by itself, creates a new COSTFUNCTIONPARAMETERGUI or raises the existing
% % %      singleton*.
% % %
% % %      H = COSTFUNCTIONPARAMETERGUI returns the handle to a new COSTFUNCTIONPARAMETERGUI or the handle to
% % %      the existing singleton*.
% % %
% % %      COSTFUNCTIONPARAMETERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
% % %      function named CALLBACK in COSTFUNCTIONPARAMETERGUI.M with the given input arguments.
% % %
% % %      COSTFUNCTIONPARAMETERGUI('Property','Value',...) creates a new COSTFUNCTIONPARAMETERGUI or raises the
% % %      existing singleton*.  Starting from the left, property value pairs are
% % %      applied to the GUI before CostFunctionParameterGUI_OpeningFcn gets called.  An
% % %      unrecognized property name or invalid value makes property application
% % %      stop.  All inputs are passed to CostFunctionParameterGUI_OpeningFcn via varargin.
% % %
% % %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
% % %      instance to run (singleton)".
% % %
% % % See also: GUIDE, GUIDATA, GUIHANDLES
% % 
% % % Edit the above text to modify the response to help AgentControllerGUI
% % 
% % % Last Modified by GUIDE v2.5 19-Mar-2009 11:56:13
% % 
% % % Begin initialization code - DO NOT EDIT
% % gui_Singleton = 1;
% % gui_State = struct('gui_Name',       mfilename, ...
% %                    'gui_Singleton',  gui_Singleton, ...
% %                    'gui_OpeningFcn', @CostFunctionParameterGUI_OpeningFcn, ...
% %                    'gui_OutputFcn',  @CostFunctionParameterGUI_OutputFcn, ...
% %                    'gui_LayoutFcn',  [] , ...
% %                    'gui_Callback',   []);
% % if nargin && ischar(varargin{1})
% %     gui_State.gui_Callback = str2func(varargin{1});
% % end
% % 
% % if nargout
% %     [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
% % else
% %     gui_mainfcn(gui_State, varargin{:});
% % end
% % % End initialization code - DO NOT EDIT
% % 
% % % --- Executes just before AgentControllerGUI is made visible.
% % function CostFunctionParameterGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% % % This function has no output args, see OutputFcn.
% % % hObject    handle to figure
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % % varargin   command line arguments to AgentControllerGUI (see VARARGIN)
% % 
% % % Choose default command line output for AgentControllerGUI
% % handles.output = hObject;
% % 
% % % Update handles structure
% % guidata(hObject, handles);
% % 
% % % This sets up the initial plot - only do when we are invisible
% % % so window can get raised using AgentControllerGUI.
% % if strcmp(get(hObject,'Visible'),'off')
% %     plot(rand(5));
% % end
% % 
% % % get initial values from AgentController{1}
% % agCont = evalin('base','env.Agents{1}.AgentController');
% % set(handles.editTargetAttraction,'String',...
% %    num2str(agCont.TargetGain));
% % 
% % 
% % % UIWAIT makes AgentControllerGUI wait for user response (see UIRESUME)
% % % uiwait(handles.figure1);
% % 
% % 
% % % --- Outputs from this function are returned to the command line.
% % function varargout = CostFunctionParameterGUI_OutputFcn(hObject, eventdata, handles)
% % % varargout  cell array for returning output args (see VARARGOUT);
% % % hObject    handle to figure
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % 
% % % Get default command line output from handles structure
% % varargout{1} = handles.output;
% % 
% % % --- Executes on button press in pushbutton1.
% % function pushbutton1_Callback(hObject, eventdata, handles)
% % % hObject    handle to pushbutton1 (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % axes(handles.axes1);
% % cla;
% % 
% % popup_sel_index = get(handles.popupmenu1, 'Value');
% % switch popup_sel_index
% %     case 1
% %         plot(rand(5));
% %     case 2
% %         plot(sin(1:0.01:25.99));
% %     case 3
% %         bar(1:.5:10);
% %     case 4
% %         plot(membrane);
% %     case 5
% %         surf(peaks);
% % end
% % 
% % 
% % % --------------------------------------------------------------------
% % function FileMenu_Callback(hObject, eventdata, handles)
% % % hObject    handle to FileMenu (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % handles;
% % 
% % 
% % % --------------------------------------------------------------------
% % function OpenMenuItem_Callback(hObject, eventdata, handles)
% % % hObject    handle to OpenMenuItem (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % file = uigetfile('*.fig');
% % if ~isequal(file, 0)
% %     open(file);
% % end
% % 
% % % --------------------------------------------------------------------
% % function PrintMenuItem_Callback(hObject, eventdata, handles)
% % % hObject    handle to PrintMenuItem (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % printdlg(handles.figure1)
% % 
% % % --------------------------------------------------------------------
% % function CloseMenuItem_Callback(hObject, eventdata, handles)
% % % hObject    handle to CloseMenuItem (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
% %                      ['Close ' get(handles.figure1,'Name') '...'],...
% %                      'Yes','No','Yes');
% % if strcmp(selection,'No')
% %     return;
% % end
% % 
% % delete(handles.figure1)
% % 
% % 
% % % --- Executes on selection change in popupmenu1.
% % function popupmenu1_Callback(hObject, eventdata, handles)
% % % hObject    handle to popupmenu1 (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % 
% % % Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
% % %        contents{get(hObject,'Value')} returns selected item from popupmenu1
% % handles;
% % 
% % 
% % % --- Executes during object creation, after setting all properties.
% % function popupmenu1_CreateFcn(hObject, eventdata, handles)
% % % hObject    handle to popupmenu1 (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    empty - handles not created until after all CreateFcns called
% % 
% % % Hint: popupmenu controls usually have a white background on Windows.
% % %       See ISPC and COMPUTER.
% % if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
% %      set(hObject,'BackgroundColor','white');
% % end
% % 
% % set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});
% % 
% % 
% % % --- Executes on slider movement.
% % function sliderTargetAttraction_Callback(hObject, eventdata, handles)
% % % hObject    handle to sliderTargetAttraction (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % 
% % % Hints: get(hObject,'Value') returns position of slider
% % %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% % setGain('TargetGain',get(hObject,'Value'));
% % set(handles.editTargetAttraction,'String',...
% %    num2str(get(hObject,'Value')));
% % 
% % % --- Executes during object creation, after setting all properties.
% % function sliderTargetAttraction_CreateFcn(hObject, eventdata, handles)
% % % hObject    handle to sliderTargetAttraction (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    empty - handles not created until after all CreateFcns called
% % 
% % % Hint: slider controls usually have a light gray background.
% % if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
% %     set(hObject,'BackgroundColor',[.9 .9 .9]);
% % end
% % 
% % 
% % % --- Executes on slider movement.
% % function sliderExploration_Callback(hObject, eventdata, handles)
% % % hObject    handle to sliderExploration (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % 
% % % Hints: get(hObject,'Value') returns position of slider
% % %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% % setGain('RegionExploration',get(hObject,'Value'));
% % set(handles.editExploration,'String',...
% %    num2str(get(hObject,'Value')));
% % 
% % 
% % % --- Executes during object creation, after setting all properties.
% % function sliderExploration_CreateFcn(hObject, eventdata, handles)
% % % hObject    handle to sliderExploration (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    empty - handles not created until after all CreateFcns called
% % 
% % % Hint: slider controls usually have a light gray background.
% % if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
% %     set(hObject,'BackgroundColor',[.9 .9 .9]);
% % end
% % 
% % 
% % % --- Executes on slider movement.
% % function sliderAgentDistraction_Callback(hObject, eventdata, handles)
% % % hObject    handle to sliderAgentDistraction (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % 
% % % Hints: get(hObject,'Value') returns position of slider
% % %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% % setGain('AgentGain',get(hObject,'Value'));
% % set(handles.editAgentDistraction,'String',...
% %    num2str(get(hObject,'Value')));
% % 
% % 
% % % --- Executes during object creation, after setting all properties.
% % function sliderAgentDistraction_CreateFcn(hObject, eventdata, handles)
% % % hObject    handle to sliderAgentDistraction (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    empty - handles not created until after all CreateFcns called
% % 
% % % Hint: slider controls usually have a light gray background.
% % if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
% %     set(hObject,'BackgroundColor',[.9 .9 .9]);
% % end
% % 
% % 
% % % --- Executes on slider movement.
% % function sliderAgentDeviation_Callback(hObject, eventdata, handles)
% % % hObject    handle to sliderAgentDeviation (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % 
% % % Hints: get(hObject,'Value') returns position of slider
% % %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% % setGain('StateDeviation',get(hObject,'Value'));
% % set(handles.editAgentDeviation,'String',...
% %    num2str(get(hObject,'Value')));
% % 
% % 
% % % --- Executes during object creation, after setting all properties.
% % function sliderAgentDeviation_CreateFcn(hObject, eventdata, handles)
% % % hObject    handle to sliderAgentDeviation (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    empty - handles not created until after all CreateFcns called
% % 
% % % Hint: slider controls usually have a light gray background.
% % if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
% %     set(hObject,'BackgroundColor',[.9 .9 .9]);
% % end
% % 
% % 
% % 
% % function editTargetAttraction_Callback(hObject, eventdata, handles)
% % % hObject    handle to editTargetAttraction (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % 
% % % Hints: get(hObject,'String') returns contents of editTargetAttraction as text
% % %        str2double(get(hObject,'String')) returns contents of editTargetAttraction as a double
% % setGain('TargetGain',get(hObject,'Value'));
% % 
% % 
% % % --- Executes during object creation, after setting all properties.
% % function editTargetAttraction_CreateFcn(hObject, eventdata, handles)
% % % hObject    handle to editTargetAttraction (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    empty - handles not created until after all CreateFcns called
% % 
% % % Hint: edit controls usually have a white background on Windows.
% % %       See ISPC and COMPUTER.
% % if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
% %     set(hObject,'BackgroundColor','white');
% % end
% % 
% % 
% % 
% % function editExploration_Callback(hObject, eventdata, handles)
% % % hObject    handle to editExploration (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % 
% % % Hints: get(hObject,'String') returns contents of editExploration as text
% % %        str2double(get(hObject,'String')) returns contents of editExploration as a double
% % setGain('RegionExploration',get(hObject,'Value'));
% % 
% % 
% % % --- Executes during object creation, after setting all properties.
% % function editExploration_CreateFcn(hObject, eventdata, handles)
% % % hObject    handle to editExploration (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    empty - handles not created until after all CreateFcns called
% % 
% % % Hint: edit controls usually have a white background on Windows.
% % %       See ISPC and COMPUTER.
% % if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
% %     set(hObject,'BackgroundColor','white');
% % end
% % 
% % 
% % 
% % function editAgentDistraction_Callback(hObject, eventdata, handles)
% % % hObject    handle to editAgentDistraction (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % 
% % % Hints: get(hObject,'String') returns contents of editAgentDistraction as text
% % %        str2double(get(hObject,'String')) returns contents of editAgentDistraction as a double
% % setGain('AgentGain',get(hObject,'Value'))
% % 
% % 
% % % --- Executes during object creation, after setting all properties.
% % function editAgentDistraction_CreateFcn(hObject, eventdata, handles)
% % % hObject    handle to editAgentDistraction (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    empty - handles not created until after all CreateFcns called
% % 
% % % Hint: edit controls usually have a white background on Windows.
% % %       See ISPC and COMPUTER.
% % if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
% %     set(hObject,'BackgroundColor','white');
% % end
% % 
% % 
% % 
% % function editAgentDeviation_Callback(hObject, eventdata, handles)
% % % hObject    handle to editAgentDeviation (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % 
% % % Hints: get(hObject,'String') returns contents of editAgentDeviation as text
% % %        str2double(get(hObject,'String')) returns contents of editAgentDeviation as a double
% % setGain('StateDeviation',get(hObject,'Value'));
% % 
% % 
% % % --- Executes during object creation, after setting all properties.
% % function editAgentDeviation_CreateFcn(hObject, eventdata, handles)
% % % hObject    handle to editAgentDeviation (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    empty - handles not created until after all CreateFcns called
% % 
% % % Hint: edit controls usually have a white background on Windows.
% % %       See ISPC and COMPUTER.
% % if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
% %     set(hObject,'BackgroundColor','white');
% % end
% % 
% % 
% % function setGain(property,value)
% % for i=1:evalin('base','length(env.Agents)')
% %     evalin('base',['env.Agents{',num2str(i),'}.AgentController.',property,'=',num2str(value)]);
% % end
% % 
