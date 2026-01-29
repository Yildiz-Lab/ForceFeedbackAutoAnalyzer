function feedback_indices = find_feedback_indices(LongAxisDec,TrapPositionDec,event_matrix,direction_trap)
    feedback_indices = [];
    for i=1:length(event_matrix(:,1))
        BeadPos = LongAxisDec(event_matrix(i,1):event_matrix(i,2));
        TrapPos = TrapPositionDec(event_matrix(i,1):event_matrix(i,2));
        
        sep_indices = find(direction_trap*(BeadPos-TrapPos)>5);
        if ~isempty(sep_indices)
            start_indices = sep_indices([1, find(diff(sep_indices) > 1) + 1]);
            end_indices = sep_indices([find(diff(sep_indices) > 1), length(sep_indices)]);
            sm = [start_indices', end_indices'];
            endpoint = sm(1,2);
            for j=1:length(sm(:,1))-1
                if sm(j+1,1)-sm(j,2)<20
                    endpoint = sm(j+1,2);
                end
            end
            feedback_indices = [feedback_indices', [event_matrix(i,1), event_matrix(i,1)+endpoint]']';
        else
            feedback_indices = [feedback_indices', [1, 2]']';
        end
    end
end