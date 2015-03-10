function sol = kuramoto
% KURAMOTO Systeme d'oscillateurs de phase couples
%   sol = kuramoto resoud un systeme de N d'oscillateurs de phase couples

% intervalle d'integration
t0 = 0;
tfinal = 500;

% nombre d'oscillateurs
N = 400;

% parametres des equations
% frequences intrinseques aleatoires
mean_freq = 1.0;
std_freq = 0.05;
omega = mean_freq + std_freq*randn(N,1);

% conditions initiales aleatoires uniforme sur le cercle
phi0 = 2*pi*rand(N,1);

% on definit la matrice de couplage
C = computeCouplingMatrix('local');

[t,phi]=solveKuramoto;
mean_field = mean(exp(1i*phi),1);
order_parameter = abs(mean(exp(1i*phi),1));
angle_parameter = angle(mean_field);

plotSolution('local')

% on met la solution dans une structure de sortie
sol.t=t;
sol.phi=phi;
sol.C = C;
sol.K = couplingStrength(t);
sol.mean_field = mean_field;
sol.order_parameter = order_parameter;
sol.angle_parameter = angle_parameter;

% FONCTIONS IMBRIQUEES----------------------------------------------------
    
    function [t,x] = solveKuramoto
        % SOLVEKURAMOTO resoud le systeme avec Euler
        
        % parametres de simulation
        dt = 0.5;
        nsteps = (tfinal-t0)/dt+1;
        t = t0:dt:tfinal;
        
        x = zeros(N,nsteps);
        x(:,1) = phi0;
        
        for ii = 1:nsteps-1
            % integre avec Euler
            x(:,ii+1) = x(:,ii) + dt * phaseEq(t(ii),x(:,ii));
            
            % reinitialisation
            ifire = (x(:,ii+1)>=2*pi);
            x(ifire,ii+1) = x(ifire,ii+1) - 2*pi;
        end
        
        function dphidt = phaseEq(t,phi)
            % PHASEEQ equations du systeme
            
            dphidt = omega + couplingStrength(t)*coupling(phi);
            
        end
        
        function c = coupling(phi)
            % COUPLING terme de couplage
            
            phase_diff = bsxfun(@minus,phi',phi);
            c = sum(C.*sin(phase_diff),2);
            
        end
        
    end

    function y = couplingStrength(t)
    % COUPLINGSTRENGTH force de couplage variable
            
        maxK = 0.4;
        midT = (tfinal-t0)/2;
        y = maxK/midT*t.*(t<=midT)+(2*maxK-maxK/midT*t).*(t>midT);
        
    end

    function C = computeCouplingMatrix(type)
    % COMPUTECOUPLINGMATRIX calcule la matrice de couplage
    % La matrice de couplage est une matrice NxN. L'entree
    % M(i,j)=1 si l'oscillateur i recoit une connexion de l'oscillateur j. La
    % matrice M est ensuite normalisee de telle sorte que la somme de chaque
    % ligne soit 1, si il y a au moins un j non-nul, ou 0 si toute la ligne est
    % nulle.
        
        switch lower(type)
            case 'local'
                % Pour un couplage local, M est une matrice NxN
                % On dispose les N oscillateurs sur une lattice (prendre N carre)
                % On connecte deux oscillateurs si ils sont voisins (4 voisins, conditions
                % de bord periodiques)
                % xi position en x des oscillateurs;
                % yi position en y des oscillateurs;
                
                if sqrt(N)~=round(sqrt(N))
                    error('N doit etre carre');
                end
                sN = sqrt(N);
                xi = mod((0:(N-1)),sN);
                yi = reshape(repmat(0:(sN-1),sN,1),N,1);
                distX = abs(bsxfun(@minus,xi',xi));
                distX(distX==(sN-1))=1;
                distY = abs(bsxfun(@minus,yi',yi));
                distY(distY==(sN-1))=1;
                dist = distX+distY;
                M = dist<=1 & dist>0;
                sumM = sum(M,2);
                C = bsxfun(@rdivide,M,sumM);
                C(isnan(C))=0;
                C = sparse(C);
                
            otherwise
                % Pour un couplage global (par defaut), M reste
                % un scalaire: M(i,j) = 1 pour tout i et j.
                M=1;
                C=M/N;
        end
        
    end

    function plotSolution(type)
        % PLOTSOLUTION Trace la solution phi
        
        figure(1); clf;
        n = size(phi,2);
        
        
        colormap gray;
        
        switch lower(type)
            case 'local'
                sN = sqrt(N);
                for i=1:n
                    subplot(131)
                    m = reshape(sin(phi(:,i)),sN,sN);
                    image((m+1)/2*64)
                    
                    subplot(132)
                    hold off
                    plot(t(1:i),mean(sin(phi(:,1:i)),1))
                    hold on
                    plot(t(1:i),order_parameter(1:i),'r')
                    
                    subplot(133)
                    theta = linspace(0,2*pi,100);
                    circle = exp(1i*theta);
                    hold off
                    plot(circle,'k')
                    hold on
                    plot(exp(1i*phi(:,i)),'o','MarkerFaceColor','b')
                    plot(mean_field(i),'*r');
                    pause(0.01)
                end
            otherwise
                theta = linspace(0,2*pi,100);
                circle = exp(1i*theta);
                for i = 1:n
                    hold off
                    plot(circle,'k')
                    hold on
                    plot(exp(1i*phi(:,i)),'o','MarkerFaceColor','b')
                    hold on
                    plot(mean_field(i),'*r');
                    pause(0.0001)
                end
        end
    end

% FIN FONCTIONS IMBRIQUEES----------------------------------------------------

end