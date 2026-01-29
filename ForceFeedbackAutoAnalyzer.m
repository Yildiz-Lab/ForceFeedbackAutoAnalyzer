clear;

%Asks the user if the trap is assisting our hindering
prompt = {'Assisting or Hindering? (a/h)'};
dlgtitle = 'Assisting or Hindering';
answer = char(inputdlg(prompt,dlgtitle));

switch answer
    case {'a','A','assisting','Assisting'}
        direction_trap = -1;
    otherwise
        direction_trap = 1;
end

%Analysis Parameters
DecFactor=20;
SampleRate=5000;
MinEventTime=0.1;
window_size=5;
threshold=15;

%Initialization
k=1;
Events=[];

while k~=0
    %This loads the data. It exits out of the code when it runs out of files. It's dumb, but it works.
    filename = strcat('Trace',num2str(k),'.csv');
    try
        data = load(filename);
    catch
        break
    end
    disp(k);
    
    %Decimates the Data
    Tdec=decimate_1sig(data(:,1),DecFactor,'median');%'average');
    LongAxisDec=decimate_1sig(data(:,2),DecFactor,'median');%'average');
    TrapPositionDec=decimate_1sig(data(:,5),DecFactor,'median');%'average');
    
    %Orients that data so that kinesin walks in the positive direction.
    ind = find(TrapPositionDec);
    if LongAxisDec(ind(1))>0
        direction_bead = 1;
    else
        direction_bead = -1;
    end
    LongAxisDec=LongAxisDec*direction_bead;
    TrapPositionDec=TrapPositionDec*direction_bead;
    
    %This finds the regions where the trap is not at zero.
    nonzero_indices = find(TrapPositionDec);
    start_indices = nonzero_indices([1, find(diff(nonzero_indices) > 1) + 1]);
    end_indices = nonzero_indices([find(diff(nonzero_indices) > 1), length(nonzero_indices)]);
    event_matrix = [start_indices', end_indices'];
    
    %From these events, this finds the regions where the trap is actually
    %applying load.
    feedback_indices=find_feedback_indices(LongAxisDec,TrapPositionDec,event_matrix,direction_trap);
    
    %This function tries to find slips (sliding window standard deviation method)
    slips = find_slips(window_size, threshold, feedback_indices, LongAxisDec);
    
    %Produces plots and accepts user input
    saved_traces = ForceFeedbackAutoAnalyzerGUI(DecFactor,SampleRate,MinEventTime,Tdec,LongAxisDec,TrapPositionDec,event_matrix,feedback_indices, slips);
    if ~isempty(saved_traces)
        left=k*ones(length(saved_traces(:,1)),1);
        Events=[Events',[left,saved_traces]']';
    end
    k=k+1;
end

writematrix(Events, 'ForceFeedbackOutput.csv')