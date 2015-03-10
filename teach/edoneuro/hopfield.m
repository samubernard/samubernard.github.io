function sol = hopfield(W,ics)
% HOPFIELD Recurrent artificial network
%  sol = hopfield(W,ic) solution du reseaux de Hopfield avec la matrice de
%  connexion W et les conditions initiales ICS. La matrice de connexion W
%  est carree de taille (NxM)^2. Les conditions initiales ICS doivent etre
%  de taille NxM.

% intervalle d'integration
t0 = 0;
tfinal = 10;
tspan = [t0 tfinal];

% options
options = odeset();

% nombre de noeuds
[n,m] = size(ics);
[N,M] = size(W);
if m*n ~= N
    error('La taille de W ne correspond pas a la taille de ICS');
end
if N ~= M
    error('W n''est pas carree');
end

% parametres 
tau = 1;
a = 20;

ic = reshape(ics,N,1);
ic = double(ic);
ic = ic/max(ic);
ic = ic - mean(ic);

mysol = solveHopfield;

colormap gray
figure(1); clf;
subplot(221)
imagesc(reshape(ic,n,m));
axis equal
title('Conditions Initiales (normalisees) ICS')
subplot(222)
x1 = deval(mysol,0.001);
imagesc(reshape(x1',n,m))
title('Etat du reseau a t = 0.001') 
axis equal
subplot(223)
x2 = deval(mysol,0.1);
imagesc(reshape(x2',n,m))
title('Etat du reseau a t = 0.1') 
axis equal
subplot(224)
xEnd = deval(mysol,10);
imagesc(reshape(xEnd',n,m))
title('Etat final du reseau') 
axis equal


sol = mysol;

% FONCTIONS IMBRIQUEES----------------------------------------------------
    
    function s = solveHopfield
        % SOLVEHOPFIELD resoud le systeme avec ode45
        
        s = ode45(@HopfieldEq,tspan,ic,options);
        
        function dxdt = HopfieldEq(~,x)
            % HOPFIELDEQ equations du systeme
            
            dxdt = -x/tau + W*atan(a*x);
            
        end
        
    end

% FIN FONCTIONS IMBRIQUEES----------------------------------------------------

end