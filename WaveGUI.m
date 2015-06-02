classdef WaveGUI < handle
    %UNTITLED7 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties 
        Handles;
        HandlesSettings;
        Timer;
        Speaker1;
        Speaker2;
        Speaker3;
    end
    
    
    methods
        function obj = WaveGUI
            obj.Timer = timer('Period',0.1,...
                              'TimerFcn',@(h,d)obj.runAnimation,...
                              'ExecutionMode','FixedRate');

%             obj.Speaker1 = SourceOfSound();
%             obj.Speaker1.setPosition([0 0]);
%             obj.Speaker1.setPhase(pi);
%             obj.Speaker2 = SourceOfSound();
%             obj.Speaker2.setPosition([10 10]);
%             obj.Speaker3 = SourceOfSound();
%             obj.Speaker3.setPosition([-10 10]);
            obj.openSettings();
%             obj.openGUI();
            
        end
        
        function openSettings(obj)
            
            hSettings = figure('Name','Settings',...
                               'NumberTitle','off',...
                               'Toolbar','none',...
                               'MenuBar','none',...
                               'Resize','off',...
                               'Position',[100 100 200 300]);
                           
            hQualityText = uicontrol('Style','Text',...
                                     'String','Select Quality',...
                                     'Position',[10 250 80 20]);
                                 
            hQuality = uicontrol('Style','popupmenu',...
                                 'String',{'High','Low'},...
                                 'Position',[10 220 80 25]);
                             
            hInitializeGUI = uicontrol('Style','pushbutton',...
                                       'String','Start GUI',...
                                       'Position',[130 10 60 20],...
                                       'Callback',@(handles,event)obj.setStart);
                           
            obj.HandlesSettings = struct('hSettings',hSettings,...
                                         'hQualityText',hQualityText,...
                                         'hQuality',hQuality,...
                                         'hInitializeGUI',hInitializeGUI);
        
        end
        
        function setStart(obj)
                if(strcmp(obj.HandlesSettings.hQuality.String,'High'))
                    set(obj.Timer,'Period',0.06);
%                     obj.Timer.Period = 0.06
                elseif(strcmp(obj.HandlesSettings.hQuality.String,'Low'))
                    set(obj.Timer,'Period',0.1);
%                     obj.Timer.Period = 0.1
                end
                closereq;
                obj.openGUI();
        end
        
        function openGUI(obj) 
            hfig = figure('Name','Wave-Machine',...
                          'NumberTitle','off',... 
                          'Position',[100 100 1024 608],... 
                          'ToolBar','none',...
                          'MenuBar','none',...
                          'Resize','off',...
                          'CloseRequestFcn',@(hObject,data)obj.closeGUI); 
           
            hStart = uicontrol('String','Start',...
                               'Style','Pushbutton',... 
                               'Position',[540 30 100 30],...
                               'Callback',@(hObject,data)obj.startAnimation); 
 
            hStop = uicontrol('String','Freeze',...
                              'Style','Pushbutton',... 
                              'Position',[660 30 100 30],...
                              'Callback',@(hObject,data)obj.stopAnimation);
                          
%                  hQuality = uicontrol('Style','popupmenu',...
%                                       'units','pixels',...
%                                       'String',{'High','Low'},...
%                                       'Position',[810 20 100 35],...
%                                       'Callback',@(hObject,data)obj.setQuality);
                          
%             hRadioControl = uipanel('Visible','on',...
%                                     'Units','pixels',...
%                                     'Position',[292.5 30 180 40],...
%                                     'Title','Switch Speaker',...
%                                     'FontSize',12);

             hRadioButtonGroup = uibuttongroup('Visible','off',...
                                              'Units','pixels',...
                                              'Position',[258 30 240 50]);
                                          
            hRadioControl1 = uicontrol('Parent',hRadioButtonGroup,...
                                       'Style','Radiobutton',...
                                       'String','Speaker 1',...
                                       'HorizontalAlignment','right',...
                                       'Position',[30 20 20 20],...
                                       'Callback',@(handles,event)obj.setSourceOfSound1Tick);
                                   
            hRadioControl2 = uicontrol('Parent',hRadioButtonGroup,...
                                       'Style','Radiobutton',...
                                       'String','Speaker 2',...
                                       'Position',[110 20 20 20],...
                                       'Callback',@(handles,event)obj.setSourceOfSound2Tick);
                                   
            hRadioControl3 = uicontrol('Parent',hRadioButtonGroup,...
                                       'Style','Radiobutton',...
                                       'String','Speaker 3',...
                                       'Position',[180 20 20 20],...
                                       'Callback',@(handles,event)obj.setSourceOfSound3Tick);
 
%             hAnimation = uipanel('Visible','on',...
%                                  'BackgroundColor','w',... 
%                                  'Units','pixels',...
%                                  'Position',[300 100 700 450]); 
                             
            hAnimationAxes = axes(...'Parent',hAnimation,...
                                  'Units','pixels',...
                                  'CLim',[-1 1],...
                                  'CLimMode','manual',...
                                  'Visible','off',...
                                  'Position',[160 20 927.5 622],...
                                  ...'XLim',[-10 10], 'YLim', [-10 10],...
                                  ...'XLimMode','manual',...
                                  ...'YLimMode','manual',...
                                  'XTick',[],...
                                  'YTick',[],...
                                  'ClippingStyle','rectangle');
                              
%             hSourceOfSound1Tick = uicontrol('Style','checkbox',...
%                                             'Position',[250 562 20 20],...
%                                             'Value',0,...
%                                             'Callback',@(handles,event)obj.setSourceOfSound1Tick);
 
            hSourceOfSound1 = uipanel('Visible','on',...
                                      'Units','pixels',... 
                                      'Position',[30 390 215 191],...
                                      'Title','Speaker 1',...
                                      'FontSize',12);
                                  
%             hSourceOfSound2Tick = uicontrol('Style','checkbox',...
%                                             'Position',[250 382 20 20],...
%                                             'Value',0,...
%                                             'Callback',@(handles,event)obj.setSourceOfSound2Tick);
                                  
            hSourceOfSound2 = uipanel('Visible','on',...
                                      'Units','pixels',... 
                                      'Position',[30 210 215 191],...
                                      'Title','Speaker 2',...
                                      'FontSize',12);
                                  
%             hSourceOfSound3Tick = uicontrol('Style','checkbox',...
%                                             'Position',[250 202 20 20],...
%                                             'Value',0,...
%                                             'Callback',@(handles,event)obj.setSourceOfSound3Tick);
                                  
            hSourceOfSound3 = uipanel('Visible','on',...
                                      'Units','pixels',... 
                                      'Position',[30 30 215 191],...
                                      'Title','Speaker 3',...
                                      'FontSize',12);
                         
            hSinus1FrequenzText = uicontrol('Parent',hSourceOfSound1,...
                                            'Style','Text',...
                                            'String','Frequency',...
                                            'Position',[10 148 180 20]);
                         
            hSinus1Frequenz = uicontrol('Parent',hSourceOfSound1,...
                                        'Style','Slider',...
                                        'Position',[10 133 170 20],...
                                        'Enable','off',...
                                        'Min',0,'Max',0.4,...
                                        'SliderStep',[0.01 0.1],...
                                        'Value',0.2,...
                                        'Callback',@(handle,event)obj.changeFrequency1);
                                    
            hSinus1AmplitudeText = uicontrol('Parent',hSourceOfSound1,...
                                             'Style','Text',...
                                             'String','Amplitude',...
                                             'Position',[10 108 180 20]);
                                    
            hSinus1Amplitude = uicontrol('Parent',hSourceOfSound1,...
                                        'Style','Slider',...
                                        'Position',[10 93 170 20],...
                                        'Enable','off',...
                                        'Min',0,'Max',20,...
                                        'SliderStep',[0.01 0.1],...
                                        'Value',5,...
                                        'Callback',@(handle,event)obj.changeAmplitude1);
                                    
            hSinus1PhaseText = uicontrol('Parent',hSourceOfSound1,...
                                         'Style','Text',...
                                         'String','Phase',...
                                         'Position',[10 68 180 20]);
                                    
            hSinus1Phase = uicontrol('Parent',hSourceOfSound1,...
                                     'Style','Slider',...
                                      'Position',[10 53 170 20],...
                                      'Enable','off',...
                                      'Min',0,'Max',2*pi,...
                                      'SliderStep',[0.01 0.1],...
                                      'Value',0,...
                                      'Callback',@(handle,event)obj.changePhase1);
                                  
            hSinus1DampingText = uicontrol('Parent',hSourceOfSound1,...
                                           'Style','Text',...
                                           'String','Damping',...
                                           'Position',[10 28 180 20]);
                                  
            hSinus1Damping = uicontrol('Parent',hSourceOfSound1,...
                                       'Style','Slider',...
                                       'Position',[10 13 170 20],...
                                       'Enable','off',...
                                       'Min',0,'Max',1,...
                                       'SliderStep',[0.01 0.1],...
                                       'Value',0,...
                                       'Callback',@(handles,event)obj.changeDamping1);
                                   
            hSinus2FrequenzText = uicontrol('Parent',hSourceOfSound2,...
                                            'Style','Text',...
                                            'String','Frequency',...
                                            'Position',[10 148 180 20]);
            
            hSinus2Frequenz = uicontrol('Parent',hSourceOfSound2,...
                                        'Style','Slider',...
                                        'Position',[10 133 170 20],...
                                        'Enable','off',...
                                        'Min',0,'Max',0.4,...
                                        'SliderStep',[0.01 0.1],...
                                        'Value',0.2,...
                                        'Callback',@(handle,event)obj.changeFrequency2);
                                    
            hSinus2AmplitudeText = uicontrol('Parent',hSourceOfSound2,...
                                             'Style','Text',...
                                             'String','Amplitude',...
                                             'Position',[10 108 180 20]);
                                    
            hSinus2Amplitude = uicontrol('Parent',hSourceOfSound2,...
                                        'Style','Slider',...
                                        'Position',[10 93 170 20],...
                                        'Enable','off',...
                                        'Min',0,'Max',10,...
                                        'SliderStep',[0.01 0.1],...
                                        'Value',5,...
                                        'Callback',@(handle,event)obj.changeAmplitude2);
                                    
            hSinus2PhaseText = uicontrol('Parent',hSourceOfSound2,...
                                         'Style','Text',...
                                         'String','Phase',...
                                         'Position',[10 68 180 20]);
                                    
            hSinus2Phase = uicontrol('Parent',hSourceOfSound2,...
                                     'Style','Slider',...
                                     'Position',[10 53 170 20],...
                                     'Enable','off',...
                                     'Min',0,'Max',2*pi,...
                                     'SliderStep',[0.01 0.1],...
                                     'Value',0,...
                                     'Callback',@(handle,event)obj.changePhase2);
                                 
            hSinus2DampingText = uicontrol('Parent',hSourceOfSound2,...
                                           'Style','Text',...
                                           'String','Damping',...
                                           'Position',[10 28 180 20]);
                                  
            hSinus2Damping = uicontrol('Parent',hSourceOfSound2,...
                                       'Style','Slider',...
                                       'Position',[10 13 170 20],...
                                       'Enable','off',...
                                       'Min',0,'Max',1,...
                                       'SliderStep',[0.01 0.1],...
                                       'Value',0,...
                                       'Callback',@(handles,event)obj.changeDamping2);
                                   
            hSinus3FrequenzText = uicontrol('Parent',hSourceOfSound3,...
                                            'Style','Text',...
                                            'String','Frequency',...
                                            'Position',[10 148 180 20]);
                                    
            hSinus3Frequenz = uicontrol('Parent',hSourceOfSound3,...
                                        'Style','Slider',...
                                        'Position',[10 133 170 20],...
                                        'Enable','off',...
                                        'Min',0,'Max',0.4,...
                                        'SliderStep',[0.01 0.1],...
                                        'Value',0.2,...
                                        'Callback',@(handle,event)obj.changeFrequency3);
                                    
            hSinus3AmplitudeText = uicontrol('Parent',hSourceOfSound3,...
                                             'Style','Text',...
                                             'String','Amplitude',...
                                             'Position',[10 108 180 20]);
                                    
            hSinus3Amplitude = uicontrol('Parent',hSourceOfSound3,...
                                        'Style','Slider',...
                                        'Position',[10 93 170 20],...
                                        'Enable','off',...
                                        'Min',0,'Max',10,...
                                        'SliderStep',[0.01 0.1],...
                                        'Value',5,...
                                        'Callback',@(handle,event)obj.changeAmplitude3);
                                    
            hSinus3PhaseText = uicontrol('Parent',hSourceOfSound3,...
                                         'Style','Text',...
                                         'String','Phase',...
                                         'Position',[10 68 180 20]);
                                    
            hSinus3Phase = uicontrol('Parent',hSourceOfSound3,...
                                        'Style','Slider',...
                                        'Position',[10 53 170 20],...
                                        'Enable','off',...
                                        'Min',0,'Max',2*pi,...
                                        'SliderStep',[0.01 0.1],...
                                        'Value',0,...
                                        'Callback',@(handle,event)obj.changePhase3);
                                    
            hSinus3DampingText = uicontrol('Parent',hSourceOfSound3,...
                                           'Style','Text',...
                                           'String','Damping',...
                                           'Position',[10 28 180 20]);
                                    
            hSinus3Damping = uicontrol('Parent',hSourceOfSound3,...
                                        'Style','Slider',...
                                        'Position',[10 13 170 20],...
                                        'Enable','off',...
                                        'Min',0,'Max',1,...
                                        'SliderStep',[0.01 0.1],...
                                        'Value',0,...
                                        'Callback',@(handles,event)obj.changeDamping3);
                                    
%             hMediumText = uicontrol('Parent',hfig,...
%                                 'Style','Text',...
%                                 'Position',[345 50 100 25],...
%                                 'String','Medium:',...
%                                 'FontSize',13);
%                             
%             hMedium = uicontrol('Parent',hfig,...
%                                 'Style','Popupmenu',...
%                                 'Position',[440 52.5 100 25],...
%                                 'String',{'Air','Water','Steel'},...
%                                 'FontSize',13);
                            
            hImage = image('Parent',hAnimationAxes,...
                           'Visible','on',...
                           'XData',[-31.4 31.4],...
                           'YData',[-31.4 31.4],...
                           'CDataMapping','scaled',...
                           'CData',zeros(449),...
                           'ButtonDownFcn',@obj.setSourceOfSound);
            
            colormap gray;
                        
            obj.Handles = struct('hfig',hfig,...
                                 'hStart',hStart,...
                                 'hStop',hStop,...
                                 ...'hQuality',hQuality,...
                                 ...'hRadioControl',hRadioControl,...
                                 'hRadioControl1',hRadioControl1,...
                                 'hRadioControl2',hRadioControl2,...
                                 'hRadioControl3',hRadioControl3,...
                                 'hRadioButtonGroup',hRadioButtonGroup,...
                                 ...'hAnimation',hAnimation,...
                                 'hAnimationAxes',hAnimationAxes,...
                                 ...'hSourceOfSound1Tick',hSourceOfSound1Tick,...
                                 'hSourceOfSound1',hSourceOfSound1,...
                                 ...'hSourceOfSound2Tick',hSourceOfSound2Tick,...
                                 'hSourceOfSound2',hSourceOfSound2,...
                                 ...'hSourceOfSound3Tick',hSourceOfSound3Tick,...
                                 'hSourceOfSound3',hSourceOfSound3,...
                                 ...'hMedium',hMedium,...
                                 ...'hMediumText',hMediumText,...
                                 'hImage',hImage,...
                                 'hSinus1FrequenzText',hSinus1FrequenzText,...
                                 'hSinus1Frequenz',hSinus1Frequenz,...
                                 'hSinus1AmplitudeText',hSinus1AmplitudeText,...
                                 'hSinus1Amplitude',hSinus1Amplitude,...
                                 'hSinus1PhaseText',hSinus1PhaseText,...
                                 'hSinus1Phase',hSinus1Phase,...
                                 'hSinus1DampingText',hSinus1DampingText,...
                                 'hSinus1Damping',hSinus1Damping,...
                                 'hSinus2FrequenzText',hSinus2FrequenzText,...
                                 'hSinus2Frequenz',hSinus2Frequenz,...
                                 'hSinus2AmplitudeText',hSinus2AmplitudeText,...
                                 'hSinus2Amplitude',hSinus2Amplitude,...
                                 'hSinus2PhaseText',hSinus2PhaseText,...
                                 'hSinus2Phase',hSinus2Phase,...
                                 'hSinus2DampingText',hSinus2DampingText,...
                                 'hSinus2Damping',hSinus2Damping,...
                                 'hSinus3FrequenzText',hSinus3FrequenzText,...
                                 'hSinus3Frequenz',hSinus3Frequenz,...
                                 'hSinus3AmplitudeText',hSinus3AmplitudeText,...
                                 'hSinus3Amplitude',hSinus3Amplitude,...
                                 'hSinus3PhaseText',hSinus3PhaseText,...
                                 'hSinus3Phase',hSinus3Phase,...
                                 'hSinus3DampingText',hSinus3DampingText,...
                                 'hSinus3Damping',hSinus3Damping);
        end
        
        
        function closeGUI(obj)
            obj.stopAnimation;
            delete(obj.Timer);
            closereq;
        end
        
        
        function startAnimation(obj)
            obj.Speaker1 = SourceOfSound();
            obj.Speaker2 = SourceOfSound();
            obj.Speaker3 = SourceOfSound();
            obj.Handles.hRadioButtonGroup.Visible = 'on';
%             obj.Handles.hStop.String = 'Stop';
            if strcmp(obj.Timer.Running,'off')
            start(obj.Timer);
            end
            if strcmp(obj.Timer.Running,'on')
            obj.Handles.hStop.String = 'Freeze';
            end
        end
        
        
        function stopAnimation(obj)
            obj.Handles.hRadioButtonGroup.Visible = 'off';
            stop(obj.Timer);
            obj.Handles.hStart.String = 'Resume';
            if strcmp(obj.Timer.Running,'off')
                obj.Handles.hStop.String = 'Stop';
            end
            %set(obj.Handles.hImage,'CData',zeros(449));
        end
        
        function setQuality(obj)
            if(strcmp(obj.Handles.hQuality.String,'High'))
               obj.Timer.Period = 0.06;
            elseif(strcmp(obj.Handles.hQuality.String,'Low'))
               obj.Timer.Period = 1;
            end
        end
        
        function runAnimation(obj)
%             tic
            obj.Handles.hImage.Visible = 'on';
            sMap1 = obj.Speaker1.getColorMap(obj.Timer.TasksExecuted);
            sMap2 = obj.Speaker2.getColorMap(obj.Timer.TasksExecuted);
            sMap3 = obj.Speaker3.getColorMap(obj.Timer.TasksExecuted);
            set(obj.Handles.hImage,'CData', sMap1 + sMap2 + sMap3);
%             toc
        end
        
        function setSourceOfSound1Tick(obj)
            if(obj.Handles.hRadioControl1.Value == 1)
                obj.Handles.hSinus1Frequenz.Enable = 'on';
                obj.Handles.hSinus1Amplitude.Enable = 'on';
                obj.Handles.hSinus1Phase.Enable = 'on';
                obj.Handles.hSinus1Damping.Enable = 'on';
                obj.Handles.hSinus2Frequenz.Enable = 'off';
                obj.Handles.hSinus2Amplitude.Enable = 'off';
                obj.Handles.hSinus2Phase.Enable = 'off';
                obj.Handles.hSinus2Damping.Enable = 'off';
                obj.Handles.hSinus3Frequenz.Enable = 'off';
                obj.Handles.hSinus3Amplitude.Enable = 'off';
                obj.Handles.hSinus3Phase.Enable = 'off';
                obj.Handles.hSinus3Damping.Enable = 'off'; 
            end
        end
        
        function setSourceOfSound2Tick(obj)
            if(obj.Handles.hRadioControl2.Value == 1)
                obj.Handles.hSinus2Frequenz.Enable = 'on';
                obj.Handles.hSinus2Amplitude.Enable = 'on';
                obj.Handles.hSinus2Phase.Enable = 'on';
                obj.Handles.hSinus2Damping.Enable = 'on';
                obj.Handles.hSinus1Frequenz.Enable = 'off';
                obj.Handles.hSinus1Amplitude.Enable = 'off';
                obj.Handles.hSinus1Phase.Enable = 'off';
                obj.Handles.hSinus1Damping.Enable = 'off';
                obj.Handles.hSinus3Frequenz.Enable = 'off';
                obj.Handles.hSinus3Amplitude.Enable = 'off';
                obj.Handles.hSinus3Phase.Enable = 'off';
                obj.Handles.hSinus3Damping.Enable = 'off';
            end
        end
        
        function setSourceOfSound3Tick(obj)
            if(obj.Handles.hRadioControl3.Value == 1)
                obj.Handles.hSinus3Frequenz.Enable = 'on';
                obj.Handles.hSinus3Amplitude.Enable = 'on';
                obj.Handles.hSinus3Phase.Enable = 'on';
                obj.Handles.hSinus3Damping.Enable = 'on';
                obj.Handles.hSinus1Frequenz.Enable = 'off';
                obj.Handles.hSinus1Amplitude.Enable = 'off';
                obj.Handles.hSinus1Phase.Enable = 'off';
                obj.Handles.hSinus1Damping.Enable = 'off';
                obj.Handles.hSinus2Frequenz.Enable = 'off';
                obj.Handles.hSinus2Amplitude.Enable = 'off';
                obj.Handles.hSinus2Phase.Enable = 'off';
                obj.Handles.hSinus2Damping.Enable = 'off'; 
            end
        end
        
        function setSourceOfSound(obj,~,event)
            if(obj.Handles.hRadioControl1.Value == 1)
                X = event.IntersectionPoint(1);
                Y = event.IntersectionPoint(2);
                obj.Speaker1.setPosition([X Y]);
                
            elseif(obj.Handles.hRadioControl2.Value == 1)
                    X = event.IntersectionPoint(1);
                    Y = event.IntersectionPoint(2);
                    obj.Speaker2.setPosition([X Y]);
            
            elseif(obj.Handles.hRadioControl3.Value == 1)
                    X = event.IntersectionPoint(1);
                    Y = event.IntersectionPoint(2);
                    obj.Speaker3.setPosition([X Y]);
            end
        end
        
        function changeFrequency1(obj)
            obj.Speaker1.setFrequency(obj.Handles.hSinus1Frequenz.Value);
        end
        
        function changeAmplitude1(obj)
            obj.Speaker1.setAmplitude(obj.Handles.hSinus1Amplitude.Value);
        end
        
        function changePhase1(obj)
            obj.Speaker1.setPhase(obj.Handles.hSinus1Phase.Value);
        end
        
        function changeDamping1(obj)
            obj.Speaker1.setDamping(obj.Handles.hSinus1Damping.Value);
        end
        
        function changeFrequency2(obj)
            obj.Speaker2.setFrequency(obj.Handles.hSinus2Frequenz.Value);
        end
        
        function changeAmplitude2(obj)
            obj.Speaker2.setAmplitude(obj.Handles.hSinus2Amplitude.Value);
        end
        
        function changePhase2(obj)
            obj.Speaker2.setPhase(obj.Handles.hSinus2Phase.Value);
        end
        
        function changeDamping2(obj)
            obj.Speaker2.setDamping(obj.Handles.hSinus2Damping.Value);
        end
        
        function changeFrequency3(obj)
            obj.Speaker3.setFrequency(obj.Handles.hSinus3Frequenz.Value);
        end
        
        function changeAmplitude3(obj)
            obj.Speaker3.setAmplitude(obj.Handles.hSinus3Amplitude.Value);
        end
        
        function changePhase3(obj)
            obj.Speaker3.setPhase(obj.Handles.hSinus3Phase.Value);
        end
        
        function changeDamping3(obj)
            obj.Speaker3.setDamping(obj.Handles.hSinus3Damping.Value);
        end
    end
end

