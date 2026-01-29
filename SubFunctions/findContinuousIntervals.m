
function result = findContinuousIntervals(arr)
    if isempty(arr)
        result = [];
        return;
    end

    start_interval = arr(1);
    end_interval = arr(1);
    result = [];

    for i = 2:length(arr)
        if arr(i) == end_interval + 1
            end_interval = arr(i);
        else
            if end_interval > start_interval
                result = [result; [start_interval, end_interval]];
            end
            start_interval = arr(i);
            end_interval = arr(i);
        end
    end

    if end_interval > start_interval
        result = [result; [start_interval, end_interval]];
    end
end
