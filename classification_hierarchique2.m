clear all;
close all;
clc;

%mx = [ 1 2  2 3 1; 1 2 6 6 4]
img = [ 0 1 5 0;
    5 5 6 0;
    5 6 1 1;
    1 4 5 0;
    0 0 4 0 ];
% 
%img = imread('/home/n3/Bureau/opencv/n3.jpg');
% 
I = unique(img);
I(:, 2) = frequence(img, I);
%I = [ 1 1; 2 2; 2 6; 3 6; 1 4];
%I = [0 7; 1 4 ; 4 2; 5 4; 6 2];
[x y] = size(I);
X = x


%historique_matrice = java.util.ArrayList;

% [mass Ix I1 I2]
historique_individu = java.util.ArrayList;

%historique_hist = java.util.ArrayList;
res_individu = x;
 
for i=1:size(I, 1)
    historique_individu.add([1 i 0 0]);
end

%
                    % ETAPE 0
%

MX = zeros(x, x);
% appliquer la formule de recurrence initial
for i=1:size(MX, 1)
    for j=1:i-1
        MX(i, j) = formule_initial(I(i, :), I(j, :));
    end
end
MX

% trouver le minimum
[ min_ pos_min_x pos_min_y ] = minimum(MX)
% indice du nouveau individu
res_individu = res_individu + 1;
%historique_matrice.add(MX);

if pos_min_x <= X && pos_min_y <= X
    historique_individu.add([2; res_individu; pos_min_x; pos_min_y]);
else
    %... puisque c l'etape 0, pas besoin
end

%historique_hist.add(I);

%historique_matrice.get(historique_matrice.size()-1)
historique_individu.get(historique_individu.size()-1)
%historique_hist.get(historique_hist.size()-1)

%
                    %ETAPE 1...
%
stop = X-2;
while stop
    stop
    x = x + 1;

    MX = [MX, zeros(x-1, 1)];
    MX = [MX; zeros(1, x)];
    
    I = [I; zeros(1, 2)];
    % le nouveau individu Ix = moyenne(v1, v2)
    % ex: I6 = { I1, I2 } et I7 = { I6, I3 }
    %       G(I6) = { I6_a, I6_b }
    %       G(I7_a) = ( mass(I6) * I6_a + mass(I3) * I3_a ) / (mass(I6)+mass(I3))  
    %       G(I7_a) = ( 2        * I6_a + 1        * I3_a)  / (2 + 1)
    %       G(I7_b) = meme chose...
    %       G(I7) a un poid = 3
    v1=historique_individu.get(pos_min_x-1);
    v2=historique_individu.get(pos_min_y-1);
    I(res_individu, 1) = (I(pos_min_x, 1)*v1(1)+I(pos_min_y, 1)*v2(1))/(v1(1)+v2(1));
    I(res_individu, 2) = (I(pos_min_x, 2)*v1(1)+I(pos_min_y, 2)*v2(1))/(v1(1)+v2(1));

    % ne plus les utilisé lord du calcule de distance
    for i=1:size(I, 1)
        if i == pos_min_x || i == pos_min_y
            for j=1:size(I, 2)
                I(i, j) = +Inf;
            end
        end
    end

    I

    % appliquer la formule de recurrence non initial
    for i=1:size(MX, 1)
        vv1=historique_individu.get(i-1);
        for j=1:i-1
            vv2=historique_individu.get(j-1);
            MX(i, j) = formule_non_initial(I(i, :), I(j, :), vv1(1), vv2(1));
        end
    end

    MX
    
    % trouver le minimum
    [ min_ pos_min_x pos_min_y ] = minimum(MX)
    % indice du nouveau individu
    res_individu = res_individu + 1;
    %historique_matrice.add(MX);

    % calcule de la mass au Ix actuel
    % la mass ( le poid ) propre au Ix actuel
    if pos_min_x <= X && pos_min_y <= X
        historique_individu.add([2; res_individu; pos_min_x; pos_min_y]);
    elseif pos_min_x <= X && X < pos_min_y
        val = 0;
        a = historique_individu.get(pos_min_y-1);
        val = val + a(1) + 1;
        historique_individu.add([val; res_individu; pos_min_x; pos_min_y]);
    elseif X < pos_min_x && pos_min_y <= X
        val = 0;
        a = historique_individu.get(pos_min_x-1);
        val = val + a(1) + 1;
        historique_individu.add([val; res_individu; pos_min_x; pos_min_y]);
    else
        val = 0;
        a = historique_individu.get(pos_min_x-1);
        b = historique_individu.get(pos_min_y-1);
        val = val + a(1) + b(1);
        historique_individu.add([val; res_individu; pos_min_x; pos_min_y]);
    end

    
    %historique_hist.add(I);

    %historique_matrice.get(historique_matrice.size()-1)
    historique_individu.get(historique_individu.size()-1)
    %historique_hist.get(historique_hist.size()-1)
    
    stop = stop - 1;
end

% l'individu qui reste en dernier seul represente une classe forte
i = historique_individu.size()-1;
forte = 0;
while 1
    if i == X break; end
    a = historique_individu.get(i);
    if a(3) <= X && a(4) <= X
        forte = 0;
        break;
    elseif a(3) <= X && X < a(4)
        forte = a(3);
        break;
    elseif X < a(3) && a(4) <= X
        forte = a(4);
        break;
    else
        forte = 0;
    end
    i = i - 1;
end

if forte == 0
    disp(['> Ya pas de classe forte']);
else
    disp(['> La classe la plus forte : I', num2str(forte)]);
end

% reglage des etapes de regroupement des individu
% ex: au lieu d'avoir I6, on a se qui le constitu
res = java.util.ArrayList;
for i=X:historique_individu.size()-1
    v = historique_individu.get(i)
    if v(3) <= X && v(4) <= X
        res.add(sort(unique([v(3) ; v(4)])));
    elseif v(3) <= X && v(4) > X
        r = res.get(v(4)-1-X);
        res.add(sort(unique([v(3) ; r])));
    elseif v(4) <= X && v(3) > X
        r = res.get(v(3)-1-X);
        res.add(sort(unique([v(4) ; r])));
    else
        r1 = res.get(v(3)-1-X);
        r2 = res.get(v(4)-1-X);
        res.add(sort(unique([r1 ; r2])));
    end
end

% for i=0:res.size()-1
%     pfff = res.get(i)
% end

par_groupe = java.util.ArrayList;
for i=1:X
    par_groupe.add(i);
end

n = 1;
% P1 est tj fix
p1 = sprintf('P%d = ', n);
n=n+1;

for i=0:X-1
    p1 = sprintf('%s { I%d }', p1, i+1);
end
p1

for i=0:res.size()-2
    xx = res.get(i);
    par_groupe.add(xx);
    
    % eliminé les groupes qui n'existe plus
    if n > 2
        v = par_groupe.get(par_groupe.size()-1);
        M = 1;
        for l1=1:size(v)
            if M == 0 break; end
            for l2=(X-1):par_groupe.size()-2
                if M == 0 break; end
                vv = par_groupe.get(l2);
                for l3=1:size(vv, 1)
                    if vv(l3) == v(l1)
                        par_groupe.remove(l2);
                        M = 0;
                        break;
                    end
                end
            end
        end
    end
    
    % chaque element de par_groupe represente un groupe
    for j=1:size(xx,1)
        par_groupe.set(xx(j)-1, +Inf);
    end
    pn = sprintf('P%d = ', n);
    for nx=0:par_groupe.size()-1
        var = par_groupe.get(nx);
        if size(var, 1) == 1 && var ~= +Inf
            pn = sprintf('%s { I%d }', pn, var);
        elseif var == +Inf
        else
            pn = sprintf('%s { ', pn);
            for ny=1:size(var, 1)
                pn = sprintf('%s I%d', pn, var(ny));
            end
             pn = sprintf('%s }', pn);
        end
    end
    pn
    n = n + 1;
end

%P dernier tj fix
pn = sprintf('P%d = { ', n);
for i=0:X-1
    pn = sprintf('%s I%d ', pn, i+1);
end
pn = sprintf('%s } ', pn);
pn






































