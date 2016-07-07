function F = frequence( I, N )
    F = N;
    for i = 1 : size(N, 1)
        count = 0;
        for ii = 1 : size(I, 1)
            for jj = 1 : size(I, 2)
                if N(i, 1) == I(ii, jj)
                    count = count + 1;
                end
            end
        end
        F(i, 1) = count;
    end
end

