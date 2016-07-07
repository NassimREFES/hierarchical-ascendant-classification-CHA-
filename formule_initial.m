function dst = formule_initial( a, b )
% centre de gravité -> S(a, b) = || Ga - Gb ||²
    dst = 0;
    for i=1:size(a, 2)
        dst = dst + (a(1, i)-b(1, i))^2;
    end
end

