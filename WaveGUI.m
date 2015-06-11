classdef WaveGUI < handle
    %WAVEGUI Summary of this class goes here
    %   Detailed explanation goes here
    
    properties 
        Handles;
        Timer;
        Resolution;
        Speakers;
        Picture;
    end
    
    methods
        function obj = WaveGUI
            obj.Picture = flipud(imread('wir.jpg'));
            obj.Timer = timer('Period',0.06,...
                              'TimerFcn',@(handle,eventdata)obj.runAnimation,...
                              'ExecutionMode','FixedRate');
            obj.setResolution(pi/28);
            obj.openGUI;  
        end
    end
        
    methods (Access = private)
        function openGUI(obj)
            
            hfig = figure('Name','Wave-Machine',...
                          'NumberTitle','off',... 
                          'Position',[100 60 1024 608],... 
                          'ToolBar','none',...
                          'MenuBar','none',...
                          'Resize','off',...
                          'CloseRequestFcn',@(handle,eventdata)obj.closeGUI); 
           
            hStart = uicontrol('String','Start',...
                               'Style','Pushbutton',...
                               'Enable','off',...
                               'Position',[20 70 100 30],...
                               'FontSize',10,...
                               'Tooltip','Start the simulation',...
                               'Callback',@(handle,eventdata)obj.startAnimation); 
 
            hClear = uicontrol('String','Clear',...
                               'Style','Pushbutton',...
                               'Enable','on',...
                               'Position',[130 70 100 30],...
                               'FontSize',10,...
                               'Tooltip','Deletes all sources',...
                               'Callback',@(handle,eventdata)obj.clearAnimation);
                                                   
            hMedium = uicontrol('Parent',hfig,...
                                'Style','Popupmenu',...
                                'Position',[20 20 100 35],...
                                'String',{'Air','Water','Steel'},...
                                'Tooltip','Choose a medium',...
                                'FontSize',10);
                            
                            
            hQuality = uicontrol('Style','popupmenu',...
                                 'String',{'High','Low'},...
                                 'Position',[130 20 100 35],...
                                 'FontSize',10,...
                                 'Tooltip','Set the quality of the simulation',...
                                 'Callback',@(handle,eventdata)obj.setQuality);
                             
            hSpeakerList = uicontrol('Style','Listbox',...
                                     'Enable','off',...
                                     'String',{},...
                                     'Position',[20 200 210 180],...
                                     'FontSize',11,...
                                     'Tooltip','List of all sources',...
                                     'Callback',@(handle,eventdata)obj.selectSpeaker);
                                 
            hLineplot = uicontrol('Style','checkbox',...
                                  'String','Select a Point',...
                                  'Position',[20 160 150 20],...
                                  'FontSize',11,...
                                  'Value',0,...
                                  'Tooltip','Select a point for the line plot',...
                                  'Callback',@(handle,eventdata)obj.setLineplot);
                                 
            hAdd = uicontrol('Style','Pushbutton',...
                             'String','Add',...
                             'Position',[20 115 100 30],...
                             'FontSize',10,...
                             'Tooltip','Adds a sound-source to the field',...
                             'Callback',@(handle,eventdata)obj.addSpeaker);
            
            hRemove = uicontrol('Style','Pushbutton',...
                                'String','Remove',...
                                'Enable','off',...
                                'Position',[130 115 100 30],...
                                'FontSize',10,...
                                'Tooltip','Removes the selected source',...
                                'Callback',@(handle,eventdata)obj.removeSpeaker);
                             
            hAnimationAxes = axes('Units','pixels',...
                                  'CLim',[-1 1],...
                                  'CLimMode','manual',...
                                  'Visible','off',...
                                  'Position',[160 -50 930 710],...
                                  'XTick',[],...
                                  'YTick',[],...
                                  'ClippingStyle','rectangle');
 
            hSetting = uipanel('Units','pixels',... 
                               'Position',[20 390 210 200],...
                               'Title','Settings',...
                               'FontSize',12);
                         
            hSettingFrequencyText = uicontrol('Parent',hSetting,...
                                              'Style','Text',...
                                              'String','Frequency',...
                                              'Tooltip','Sets the frequency of the selected source',...
                                              'Position',[20 160 180 20]);
                         
            hSettingFrequency = uicontrol('Parent',hSetting,...
                                          'Style','Slider',...
                                          'Position',[15 140 180 20],...
                                          'Enable','off',...
                                          'Min',0,'Max',0.4,...
                                          'SliderStep',[0.01 0.1],...
                                          'Value',0.2,...
                                          'Tooltip','Sets the frequency of the selected source',...
                                          'Callback',@(handle,eventdata)obj.changeFrequency);
                                    
            hSettingAmplitudeText = uicontrol('Parent',hSetting,...
                                              'Style','Text',...
                                              'String','Amplitude',...
                                              'Tooltip','Sets the amplitude of the selected source',...
                                              'Position',[20 120 180 20]);
                                    
            hSettingAmplitude = uicontrol('Parent',hSetting,...
                                          'Style','Slider',...
                                          'Position',[15 100 180 20],...
                                          'Enable','off',...
                                          'Min',0,'Max',10,...
                                          'SliderStep',[0.01 0.1],...
                                          'Value',5,...
                                          'Tooltip','Sets the amplitude of the selected source',...
                                          'Callback',@(handle,eventdata)obj.changeAmplitude);
                                    
            hSettingPhaseText = uicontrol('Parent',hSetting,...
                                          'Style','Text',...
                                          'String','Phase',...
                                          'Tooltip','Sets the phase of the selected source',...
                                          'Position',[15 80 180 20]);
                                    
            hSettingPhase = uicontrol('Parent',hSetting,...
                                      'Style','Slider',...
                                      'Position',[15 60 180 20],...
                                      'Enable','off',...
                                      'Min',0,'Max',2*pi,...
                                      'SliderStep',[0.01 0.1],...
                                      'Value',0,...
                                      'Tooltip','Sets the phase of the selected source',...
                                      'Callback',@(handle,eventdata)obj.changePhase);
                                  
            hSettingDampingText = uicontrol('Parent',hSetting,...
                                            'Style','Text',...
                                            'String','Damping',...
                                            'Tooltip','Sets the damping of the selected source',...
                                            'Position',[15 40 180 20]);
                                  
            hSettingDamping = uicontrol('Parent',hSetting,...
                                        'Style','Slider',...
                                        'Position',[15 20 180 20],...
                                        'Enable','off',...
                                        'Min',0,'Max',1,...
                                        'SliderStep',[0.01 0.1],...
                                        'Value',0,...
                                        'Tooltip','Sets the phase of the selected source',...
                                        'Callback',@(handle,eventdata)obj.changeDamping);
                                   
            hImage = image('Parent',hAnimationAxes,...
                           'Visible','on',...
                           'XData',[-31.4 31.4],...
                           'YData',[-31.4 31.4],...
                           'CDataMapping','scaled',...
                           'CData',obj.Picture,...
                           'ButtonDownFcn',@obj.setSourceOfSound);
            
            colormap gray;
                        
            obj.Handles = struct('hfig',hfig,...
                                 'hStart',hStart,...
                                 'hClear',hClear,...
                                 'hQuality',hQuality,...
                                 'hMedium',hMedium,...
                                 'hAdd',hAdd,...
                                 'hRemove',hRemove,...
                                 'hSpeakerList',hSpeakerList,...
                                 'hLineplot',hLineplot,...
                                 'hAnimationAxes',hAnimationAxes,...
                                 'hSetting',hSetting,...
                                 'hImage',hImage,...
                                 'hSettingFrequencyText',hSettingFrequencyText,...
                                 'hSettingFrequency',hSettingFrequency,...
                                 'hSettingAmplitudeText',hSettingAmplitudeText,...
                                 'hSettingAmplitude',hSettingAmplitude,...
                                 'hSettingPhaseText',hSettingPhaseText,...
                                 'hSettingPhase',hSettingPhase,...
                                 'hSettingDampingText',hSettingDampingText,...
                                 'hSettingDamping',hSettingDamping);
        end
        
        function closeGUI(obj)
            obj.clearAnimation;
            delete(obj.Timer);
            closereq;
        end
        
        function startAnimation(obj)
            if strcmp(obj.Timer.Running,'off')
                start(obj.Timer);
                obj.Handles.hStart.String = 'Freeze';
            elseif strcmp(obj.Timer.Running,'on')
                stop(obj.Timer);
                obj.Handles.hStart.String = 'Start';
            end
        end
        
        function clearAnimation(obj)
            stop(obj.Timer);
            obj.Handles.hStart.String = 'Start';
            set(obj.Handles.hImage,'CData',obj.Picture);
        end
        
        function runAnimation(obj)
            obj.Handles.hImage.Visible = 'on';
            size = length(-10*pi:obj.Resolution:10*pi);
            sMap = zeros(size);
            for i = 1:length(obj.Speakers)
                sMap = sMap + obj.Speakers{i}.getColorMap(obj.Timer.TasksExecuted);
            end
            set(obj.Handles.hImage,'CData',sMap);

        end
  
        function addSpeaker(obj)
            obj.Speakers{length(obj.Speakers)+1} = SourceOfSound();
            obj.Speakers{length(obj.Speakers)}.setPosition([(rand(1)-0.5)*10*pi (rand(1)-0.5)*10*pi]);
            obj.Speakers{length(obj.Speakers)}.setResolution(obj.Resolution);
            obj.Handles.hStart.Enable = 'on';
            obj.Handles.hSpeakerList.Enable = 'on';
            obj.Handles.hRemove.Enable = 'on';
            obj.Handles.hSpeakerList.String = [obj.Handles.hSpeakerList.String; cellstr(strcat('Speaker',num2str(length(obj.Speakers))))];
            obj.Handles.hSpeakerList.Value = length(obj.Speakers);
            obj.selectSpeaker;
            if length(obj.Speakers) == 5
                warndlg('We recommend no more Speakers!','Speaker-overflow');
            end
        end
        
        function removeSpeaker(obj)
                stop(obj.Timer);
                speakerNr = obj.Handles.hSpeakerList.Value;
                delete (obj.Speakers{speakerNr});
                obj.Speakers(1:speakerNr-1)
                obj.Speakers = [obj.Speakers(1:speakerNr-1) obj.Speakers(speakerNr+1:end)];
                index = obj.Handles.hSpeakerList.Value;
                obj.Handles.hSpeakerList.String(index) = [];
                obj.Handles.hSpeakerList.Value = 1;
                start(obj.Timer);
        end
        
        function selectSpeaker(obj)
                index = obj.Handles.hSpeakerList.Value;
                if strcmp(obj.Handles.hSpeakerList.String(index),'deleted')
                    obj.Handles.hRemove.Enable = 'off';
                else
                    obj.Handles.hRemove.Enable = 'on';
                end
            obj.setSetting;
        end
        
        function setSetting(obj)
            if ~isempty(obj.Handles.hSpeakerList.Value)
                currentSpeaker = obj.Speakers{obj.Handles.hSpeakerList.Value};
                obj.Handles.hSettingFrequency.Value = currentSpeaker.Frequency;
                obj.Handles.hSettingAmplitude.Value = currentSpeaker.Amplitude;
                obj.Handles.hSettingPhase.Value = currentSpeaker.Phase;
                obj.Handles.hSettingDamping.Value = currentSpeaker.Damping;
                obj.Handles.hSettingFrequency.Enable = 'on';
                obj.Handles.hSettingAmplitude.Enable = 'on';
                obj.Handles.hSettingPhase.Enable = 'on';
                obj.Handles.hSettingDamping.Enable = 'on';
            end
        end
        
        function setSourceOfSound(obj,~,event)
            
            X = event.IntersectionPoint(1);
            Y = event.IntersectionPoint(2);
            
            if isempty(obj.Handles.hSpeakerList.String)
                return;
            end
            if obj.Handles.hLineplot.Value == 0
                speakerNr = obj.Handles.hSpeakerList.Value;
                obj.Speakers{speakerNr}.setPosition([X Y]);
            elseif obj.Handles.hLineplot.Value == 1
                obj.setLineplot(X,Y);
            end
        end
        
        function setLineplot(obj,X,Y)
            
        end

        function setQuality(obj)
            
            isRunning = 0;
            
            if strcmp(obj.Timer.Running,'on')
                isRunning = 1;
            end
            
            stop(obj.Timer);
            quality = obj.Handles.hQuality.String(obj.Handles.hQuality.Value);
            if(strcmp(quality,'High'))
                obj.Timer.Period = 0.06;
            elseif(strcmp(quality,'Low'))
                obj.Timer.Period = 0.1;
            end
            
            if isRunning == 1
                start(obj.Timer);
            end
        end
        
        function changeFrequency(obj)
            frequency = obj.Handles.hSettingFrequency.Value;
            speakerNr = obj.Handles.hSpeakerList.Value;
            obj.Speakers{speakerNr}.setFrequency(frequency);
        end
        
        function changeAmplitude(obj)
            amplitude = obj.Handles.hSettingAmplitude.Value;
            speakerNr = obj.Handles.hSpeakerList.Value;
            obj.Speakers{speakerNr}.setAmplitude(amplitude);
        end
        
        function changePhase(obj)
            phase = obj.Handles.hSettingPhase.Value;
            speakerNr = obj.Handles.hSpeakerList.Value;
            obj.Speakers{speakerNr}.setPhase(phase);
        end
        
        function changeDamping(obj)
            damping = obj.Handles.hSettingDamping.Value;
            speakerNr = obj.Handles.hSpeakerList.Value;
            obj.Speakers{speakerNr}.setDamping(damping);
        end
        
        function setResolution(obj, resolution)
            obj.Resolution = resolution;
            for i = 1:length(obj.Speakers)
                obj.Speakers{i}.setResolution(resolution);
            end
        end
    end
end
