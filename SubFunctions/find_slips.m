function slips = find_slips(window_size, threshold, feedback_indices, LongAxisDec)
    slips=[];
    for i=1:length(feedback_indices(:,1))
        BeadPos = LongAxisDec(feedback_indices(i,1):feedback_indices(i,2));
        for j = 1:(length(BeadPos) - window_size + 1)
            window = BeadPos(j:j+window_size-1);
            if std(window)>threshold
                slips=[slips',[i, feedback_indices(i,1)+j+floor(window_size/2)]']';
            end
        end
    end
end