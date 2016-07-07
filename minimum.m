function [ min_ pos_min_x pos_min_y ] = minimum( MX )
    min_ = +Inf;
    pos_min_x = 0;
    pos_min_y = 0;
    for i=1:size(MX, 1)
        for j=1:i-1
            if MX(i, j) < min_
                min_ = MX(i, j);
                pos_min_x = i;
                pos_min_y = j;
            end
        end
    end
end
