function [] = old_vehicle_suspension_model(dis_R, dis_F, Z, T, H)
close all
% Clear workspace and set plotting flags

ploton1 = 1;            % animate qcar response
ploton2 = 2;            % plot response

% Initialize vehicle parameters:
C = 3;               % specify suspension design case
switch C
    case 1           % tuned for comfort
        k = 500.4;
        c = 24.67;
    case 2           % tuned for handling
        k = 505.33;
        c = 1897.9;
    case 3           % not optimal
        k = 1000;
        c = 1000;
end

ms = 325;               % 1/4 sprung mass (kg)
mus = 65;               % 1/4 unsprung mass (kg)
kus = 232.5e3;          % tire stiffness (N/m)
grav = 9.81;            % acceleration of gravity (m/s^2)
v = 10;                 % vehicle velocity (m/s)
dt = 0.005;             % simulation time step

% Construct linear state space model
Aqcar = [0 1 0 0;-kus/mus -c/mus k/mus c/mus;0 -1 0 1;0 c/ms -k/ms -c/ms];
Bqcar = [-1 0 0 0]'; Cqcar = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1; 0 -1 0 1];
Dqcar = 0;
qcar = ss(Aqcar,Bqcar,Cqcar,Dqcar);

% note: y(:,1-4) = x, y(:,5) = d/dt susp stroke (i.e., x3dot)
% Definition of System States:
% x(1) = z1-z0 = L1     tire deflection
% x(2) = z1dot          wheel cm velocity
% x(3) = z2-z1 = L2     suspension stroke (deflection)
% x(4) = z2dot          sprung mass velocity

% Initialize simulation
x0 = [0 0 0 0]';                        % initial state
load IRI_737b                           % road profile data

dx = road_x(2) - road_x(1);             % spacial step for input data
dt2 = dx/v;                             % time step for input data
z0dot = [0 diff(road_z)/dt2];            % road profile velocity
tmax = 5;                               % simulation time length
t = 0:dt:tmax; x = v*t;                 % time/space steps to record output
u = interp1(road_x,z0dot,x);umf = 1;    % prepare simulation input

% Simulate quarter car model
y = lsim(qcar,u*umf,t,x0);
deltamaxf = max(abs(y(:,1)));           % max x3 amplitude
z2dotdot = [0 diff(y(:,4))'/dt2];       % sprung mass acceleration

% animate response
if ploton1
    z0 = interp1(road_x,road_z,x)'*umf; % road elevation
    z1 = z0 + y(:,1);                   % wheel cm position
    z2 = z1 + y(:,3);                   % sprung mass position
    
    filename = 'testnew51.gif';
    
    for i=1:length(dis_R.data)
        multiplier = 1;
        groundOffset = 0.12;
        wheelOffset = 0.25;
        pos_R = dis_R.data(i)*multiplier;
        pos_F = dis_F.data(i)*multiplier;
        pos_M = Z.data(i)*multiplier;
        angle_M = T.data(i)*multiplier*10000;
        road = z0(i);
        plot_suspension([road, pos_R, pos_F, pos_M, angle_M, t(i)],road_x,road_z,x(i),umf,H);
        drawnow
        
        
        
        frame = getframe(1);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        if i == 1;
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
        else
            imwrite(imind,cm,filename,'gif','WriteMode','append');
        end
    end
end

% % plot response
% if ploton2
%     figure(2);clf
%     plot(t,y(:,3),'r-',t,y(:,5),'k-'); hold on
%     plot(t,u*umf);
%     plot(t,z2dotdot,'g-')
%     legend('stroke','stroke velocity', ...
%         'road input velocity','sprung mass accel')
% end


end