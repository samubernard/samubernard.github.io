function simulation_output = fitzhughnagumo()
% FITZHUGHNAGUMO simule le modele de potentiel d'action de Fitzhugh-Nagumo

% Parametres du modele
a = 0.08;
b = 0.7;
c = 0.8;

% Parametres de courant applique
t0 = 10;
duree = 100; % 
intensite = 0.4; 

% Parametres de simulation
tspan = [0, 200]; % intervalle d'integration
ic = [-1.1993;
      -0.6243]; % conditions initiales

sol = ode45(@fitz,tspan,ic);

% plot des solutions
nx = 400;
xint = linspace(tspan(1),tspan(2),nx);
figure(1); clf;
yint = deval(sol,xint);

% plot des nullclines
vv = linspace(-2.5,2.5);
v_null_nostim = vv - vv.^3/3;
v_null_stim = vv - vv.^3/3 + intensite;
w_null = (vv + b)/c;

% evolution temporelle
subplot(121)
plot(xint,yint)
hold on             % qui ne s'effacera pas a chaque appel de plot
axis([tspan(1) tspan(2) -2.5 2.5]); 
axis square
xlabel('t'); ylabel('x');
legend('V - potentiel de la membrane', ...
    'W - variable de recuperation')

% portrait de phase
subplot(122)
plot(yint(1,:),yint(2,:),'k')
hold on
plot(vv,v_null_nostim,vv,w_null,vv,v_null_stim)
axis([-2.5 2.5 -1.5 1.5]); 
axis square
xlabel('V - potentiel de la membrane'); 
ylabel('W - variable de recuperation');
legend('trajectoire de (V,W)', ...
       'nullcline de V repos', ...
       'nullcline de W', ...
       'nullcline de V stimule','Location','South');


simulation_output = sol;

% Fonctions imbriquees
% ------------------------------------------------------------------

    function dxdt = fitz(t,x)
    % FITZ EDO pour le modele de Fitzhugh-Nagumo
        
        % variables dynamiques
        v = x(1); % potentiel de la membrane
        w = x(2); % variable de recuperation
        
        % equations differentielles
        dxdt = [ v - v.^3/3 - w + input_current(t);
            a*( v + b - c*w )];
        
    end

    function I = input_current(t)
    % INPUT_CURRENT courant applique a la membrane
        
        I = intensite * ( (t >= t0) & (t < (t0 + duree)) );
    
    end

% ------------------------------------------------------------------

end
