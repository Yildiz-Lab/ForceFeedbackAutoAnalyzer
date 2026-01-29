
function saved_traces = ForceFeedbackAutoAnalyzerGUI(DecFactor,SampleRate,MinEventTime,Tdec,LongAxisDec,TrapPositionDec,event_matrix,feedback_indices, slips)
    saved_traces=[];
    
    fig = uifigure('Visible', 'off');
    fig.Position = [100 100 899 480];
    fig.Name = 'UI Figure';

    % Create UIAxes
    UIAxes = uiaxes(fig);
    title(UIAxes, 'Whole Event')
    xlabel(UIAxes, 'Time (s)')
    ylabel(UIAxes, 'Distance (nm)')
    UIAxes.Position = [1 246 300 185];

    % Create UIAxes2
    UIAxes2 = uiaxes(fig);
    title(UIAxes2, 'Constant Force')
    xlabel(UIAxes2, 'Time (s)')
    ylabel(UIAxes2, 'Distance (nm)')
    UIAxes2.Position = [300 246 300 185];

    % Create UIAxes3
    UIAxes3 = uiaxes(fig);
    title(UIAxes3, 'Slip Corrected')
    xlabel(UIAxes3, 'Time (s)')
    ylabel(UIAxes3, 'Distance (nm)')
    UIAxes3.Position = [599 246 300 185];
    
    % Create RunLengthEditFieldLabel
    RunLengthEditFieldLabel = uilabel(fig);
    RunLengthEditFieldLabel.HorizontalAlignment = 'right';
    RunLengthEditFieldLabel.Position = [64 204 67 22];
    RunLengthEditFieldLabel.Text = 'Run Length';

    % Create RunLengthEditField
    RunLengthEditField = uieditfield(fig, 'numeric');
    RunLengthEditField.Position = [146 204 100 22];

    % Create RunTimeEditFieldLabel
    RunTimeEditFieldLabel = uilabel(fig);
    RunTimeEditFieldLabel.HorizontalAlignment = 'right';
    RunTimeEditFieldLabel.Position = [75 159 57 22];
    RunTimeEditFieldLabel.Text = 'Run Time';

    % Create RunTimeEditField
    RunTimeEditField = uieditfield(fig, 'numeric');
    RunTimeEditField.Position = [147 159 100 22];

    % Create RunLengthEditField_2Label
    RunLengthEditField_2Label = uilabel(fig);
    RunLengthEditField_2Label.HorizontalAlignment = 'right';
    RunLengthEditField_2Label.Position = [358 204 67 22];
    RunLengthEditField_2Label.Text = 'Run Length';

    % Create RunLengthEditField_2
    RunLengthEditField_2 = uieditfield(fig, 'numeric');
    RunLengthEditField_2.Position = [440 204 100 22];

    % Create RunTimeEditField_2Label
    RunTimeEditField_2Label = uilabel(fig);
    RunTimeEditField_2Label.HorizontalAlignment = 'right';
    RunTimeEditField_2Label.Position = [367 159 57 22];
    RunTimeEditField_2Label.Text = 'Run Time';

    % Create RunTimeEditField_2
    RunTimeEditField_2 = uieditfield(fig, 'numeric');
    RunTimeEditField_2.Position = [439 159 100 22];

    % Create RunLengthEditField_3Label
    RunLengthEditField_3Label = uilabel(fig);
    RunLengthEditField_3Label.HorizontalAlignment = 'right';
    RunLengthEditField_3Label.Position = [656 204 67 22];
    RunLengthEditField_3Label.Text = 'Run Length';

    % Create RunLengthEditField_3
    RunLengthEditField_3 = uieditfield(fig, 'numeric');
    RunLengthEditField_3.Position = [738 204 100 22];

    % Create RunTimeEditField_3Label
    RunTimeEditField_3Label = uilabel(fig);
    RunTimeEditField_3Label.HorizontalAlignment = 'right';
    RunTimeEditField_3Label.Position = [666 159 57 22];
    RunTimeEditField_3Label.Text = 'Run Time';

    % Create RunTimeEditField_3
    RunTimeEditField_3 = uieditfield(fig, 'numeric');
    RunTimeEditField_3.Position = [738 159 100 22];

    % Create SaveButton
    SaveButton = uibutton(fig, 'push');
    SaveButton.Position = [147 100 100 22];
    SaveButton.Text = 'Save';
    SaveButton.Enable='off';

    % Create SaveButton_2
    SaveButton_2 = uibutton(fig, 'push');
    SaveButton_2.Position = [440 100 100 22];
    SaveButton_2.Text = 'Save';
    SaveButton_2.Enable='off';

    % Create SaveButton_3
    SaveButton_3 = uibutton(fig, 'push');
    SaveButton_3.Position = [738 100 100 22];
    SaveButton_3.Text = 'Save';
    SaveButton_3.Enable='off';

    % Create ExitButton
    SkipButton = uibutton(fig, 'push');
    SkipButton.Position = [440 26 100 22];
    SkipButton.Text = 'Skip';
    
    SaveButton.ButtonPushedFcn = @SaveButton_Pushed;
    SaveButton_2.ButtonPushedFcn = @SaveButton2_Pushed;
    SaveButton_3.ButtonPushedFcn = @SaveButton3_Pushed;
    SkipButton.ButtonPushedFcn = @SkipButton_Pushed;
    
    fig.Visible = 'on';
    
    function SaveButton_Pushed(src, event)
        saved_traces = [saved_traces',[RunLengthEditField.Value, RunTimeEditField.Value]']';
        src.Enable = 'off';
        uiresume(fig);
    end

    function SaveButton2_Pushed(src, event)
        saved_traces = [saved_traces',[RunLengthEditField_2.Value, RunTimeEditField_2.Value]']';
        src.Enable = 'off';
        uiresume(fig);
    end

    function SaveButton3_Pushed(src, event)
        saved_traces = [saved_traces',[RunLengthEditField_3.Value, RunTimeEditField_3.Value]']';
        src.Enable = 'off';
        uiresume(fig);
    end

    function SkipButton_Pushed(src, event)
        src.Enable = 'off';
        uiresume(fig);
    end
    
    for i=1:length(event_matrix(:,1))
        if (feedback_indices(i,2)-feedback_indices(i,1))>=0.5*MinEventTime/(1/(SampleRate/DecFactor))
            plot(UIAxes,Tdec(event_matrix(i,1):event_matrix(i,2)),LongAxisDec(event_matrix(i,1):event_matrix(i,2)),'r-','LineWidth',0.5)
            hold(UIAxes, 'on')
            plot(UIAxes,Tdec(event_matrix(i,1):event_matrix(i,2)),TrapPositionDec(event_matrix(i,1):event_matrix(i,2)),'b-','LineWidth',0.5)
            hold(UIAxes, 'off')
            
            if ~isempty(slips)
                indices = slips(slips(:,1)==i, 2);
                slip_regions=findContinuousIntervals(indices);
            else
                slip_regions=[];
            end
            plot(UIAxes2,Tdec(feedback_indices(i,1):feedback_indices(i,2)),LongAxisDec(feedback_indices(i,1):feedback_indices(i,2)),'r-','LineWidth',0.5)
            hold(UIAxes2, 'on')
            plot(UIAxes2,Tdec(feedback_indices(i,1):feedback_indices(i,2)),TrapPositionDec(feedback_indices(i,1):feedback_indices(i,2)),'b-','LineWidth',0.5)
            minimum=min([min(LongAxisDec(feedback_indices(i,1):feedback_indices(i,2))),min(TrapPositionDec(feedback_indices(i,1):feedback_indices(i,2)))]);
            maximum=max([max(LongAxisDec(feedback_indices(i,1):feedback_indices(i,2))),max(TrapPositionDec(feedback_indices(i,1):feedback_indices(i,2)))]);
            if ~isempty(slip_regions)
                for j=1:length(slip_regions(:,1))
                    left=Tdec(slip_regions(j,1));
                    right=Tdec(slip_regions(j,2));
                    patch(UIAxes2,[left,right,right,left],[minimum,minimum,maximum,maximum],'r','FaceAlpha',0.5)
                end
            end
            hold(UIAxes2, 'off')
        
            if isempty(slip_regions)
                end_index=feedback_indices(i,2);
                plot(UIAxes3,Tdec(feedback_indices(i,1):feedback_indices(i,2)),LongAxisDec(feedback_indices(i,1):feedback_indices(i,2)),'r-','LineWidth',0.5)
                hold(UIAxes3, 'on')
                plot(UIAxes3,Tdec(feedback_indices(i,1):feedback_indices(i,2)),TrapPositionDec(feedback_indices(i,1):feedback_indices(i,2)),'b-','LineWidth',0.5)
                RunLength=-mean(TrapPositionDec(feedback_indices(i,1):feedback_indices(i,1)+2))+mean(TrapPositionDec(feedback_indices(i,2)-2:feedback_indices(i,2)));
            else
                corrected_traces = slip_correction(slip_regions,feedback_indices(i,:),LongAxisDec, TrapPositionDec);
                end_index = feedback_indices(i,1)+length(corrected_traces(1,:))-1;
                plot(UIAxes3,Tdec(feedback_indices(i,1):end_index),corrected_traces(1,:),'r-','LineWidth',0.5)
                hold(UIAxes3, 'on')
                plot(UIAxes3,Tdec(feedback_indices(i,1):end_index),corrected_traces(2,:),'b-','LineWidth',0.5)
                temp_index = end_index-feedback_indices(i,1);
                if length(corrected_traces(2,:))>3
                    RunLength=-mean(corrected_traces(2,1:3))+mean(corrected_traces(2,temp_index-1:temp_index+1));
                else
                    RunLength=0;
                end
            end
            hold(UIAxes3, 'off')
        
        
            RunLengthEditField.Value=-mean(TrapPositionDec(event_matrix(i,1):event_matrix(i,1)+2))+mean(TrapPositionDec(event_matrix(i,2)-2:event_matrix(i,2)));
            RunTimeEditField.Value=0.004*(event_matrix(i,2)-event_matrix(i,1));
            RunLengthEditField_2.Value=-mean(TrapPositionDec(feedback_indices(i,1):feedback_indices(i,1)+2))+mean(TrapPositionDec(feedback_indices(i,2)-2:feedback_indices(i,2)));
            RunTimeEditField_2.Value=0.004*(feedback_indices(i,2)-feedback_indices(i,1));
            RunLengthEditField_3.Value=RunLength;
            RunTimeEditField_3.Value=0.004*(end_index-feedback_indices(i,1));
        
            SaveButton.Enable='on';
            SaveButton_2.Enable='on';
            SaveButton_3.Enable='on';
            SkipButton.Enable='on';
            uiwait(fig)
        
            SaveButton.Enable='off';
            SaveButton_2.Enable='off';
            SaveButton_3.Enable='off';
            SkipButton.Enable='off';
        end
    end
    close(fig)
end

