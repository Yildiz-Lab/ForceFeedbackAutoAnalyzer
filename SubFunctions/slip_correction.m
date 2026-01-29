function corrected_traces = slip_correction(slip_regions, indices, LongAxisDec, TrapPositionDec)
    start_index = indices(1);
    end_index = indices(2);
    for i=1:length(slip_regions(:,1))
        if indices(2)-slip_regions(i,2)<4
            end_index = slip_regions(i,1)-1;
        elseif slip_regions(i,1)-indices(1)<4
            start_index = slip_regions(i,2)+1;
        else
            LongAxisDec(slip_regions(i,1):slip_regions(i,2))=LongAxisDec(slip_regions(i,1)-1);
            TrapPositionDec(slip_regions(i,1):slip_regions(i,2))=TrapPositionDec(slip_regions(i,1)-1);
            adjustment_L = mean(LongAxisDec(slip_regions(i,2)+1:slip_regions(i,2)+3))-mean(LongAxisDec(slip_regions(i,1)-3:slip_regions(i,1)-1));
            adjustment_T = mean(TrapPositionDec(slip_regions(i,2)+1:slip_regions(i,2)+3))-mean(TrapPositionDec(slip_regions(i,1)-3:slip_regions(i,1)-1));
            LongAxisDec(slip_regions(i,2)+1:length(LongAxisDec))=LongAxisDec(slip_regions(i,2)+1:length(LongAxisDec))-adjustment_L;
            TrapPositionDec(slip_regions(i,2)+1:length(TrapPositionDec))=TrapPositionDec(slip_regions(i,2)+1:length(TrapPositionDec))-adjustment_T;
        end
    end
    corrected_traces=zeros(2,end_index-start_index+1);
    corrected_traces(1,:)=LongAxisDec(start_index:end_index);
    corrected_traces(2,:)=TrapPositionDec(start_index:end_index);
end