function dst = formule_non_initial( a, b, mass_a, mass_b )
% S(a, b) = (Pa * Pb)/(Pa + Pb) * || Ga - Gb ||²
    dst = 0;
    for i=1:size(a, 2)
        dst = dst + (a(1, i)-b(1, i))^2;
    end
    dst = dst * (mass_a*mass_b)/(mass_a+mass_b);
end