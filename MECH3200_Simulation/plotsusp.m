function plotsusp(x,road_x,road_z,curr_x,umf)
% Plots quarter car suspension model at a single instant of time.
%
% Author: James T. Allison, Assistant Professor, University of Illinois at
% Urbana-Champaign
% Date: 3/4/12

% Vehicle positions:
z0 = x(1);          % road elevation
z1 = x(2);          % unsprung mass cm deviation
z2 = x(3);          % sprung mass cm deviation
t = x(4);           % current time

% Geometric suspension parameters:
h1 = 0.35;          % resting position of unsprung cm
h2 = 1.1;           % resting position of sprung cm
h3 = 0.2;           % height of unsprung mass block
h4 = 0.35;          % height of sprung mass block
w1 = 0.4;           % width of unsprung mass block
w2 = 0.5;           % width of sprung mass block
w3 = 0.1;           % width of tire spring
w4 = 0.15;          % width of suspension spring
w5 = 0.25;          % spring/damper spacing

% Plotting parameter
fw = 0.7;           % half of figure width

% Preliminary calculations:
x0_r = z0;          % tire spring base position
x0_s = h1+z1+h3/2;  % suspension spring base position
x0_t = h1+z1-h3/2;  % unsprung mass block base position
x0_b = h2+z2-h4/2;  % spring mass block base position
L1 = x0_t-x0_r;     % tire spring length
L2 = x0_b-x0_s;     % suspension spring length

% Display current simulation time
text(fw/2,1.4,[num2str(t,'%2.1f') ' sec']);

% Plot road profile
dx = road_x(2) - road_x(1);
xstart = max([curr_x-fw,0]);
[~,istart] = min(abs(xstart-road_x));
xend = curr_x + fw;
[~,iend] = min(abs(xend-road_x));
xpstart = xstart-curr_x;
xpend = fw;
zp = road_z(istart:iend)*umf;
xp = xpstart:dx:xpend;
maxi = min([length(xp),length(zp)]);
figure(1);clf
plot(xp(1:maxi),zp(1:maxi),'k-'); hold on
screenSize = 0.75;
    axis([-screenSize screenSize -0.25 1.5]);
offset = [-0.3,0.3];

% Plot sprung mass block
x0b = [0;x0_b];
x1b = x0b + [-w2/2;0];
x2b = x0b + [-w2/2;h4];
x3b = x0b + [w2/2;h4];
x4b = x0b + [w2/2;0];

x1b(1) = x1b(1) + offset(1);
x2b(1) = x2b(1) + offset(1);
x3b(1) = x3b(1) + offset(2);
x4b(1) = x4b(1) + offset(2);

fill([x1b(1) x2b(1) x3b(1) x4b(1)],[x1b(2) x2b(2) x3b(2) x4b(2)], ...
    [65 105 225]/255)

for i = 1 : 1 : 2
    % Plot unsprung mass block
    x0t = [(offset(i));x0_t];

    
    
    wheelSize = 75;
    % Plot tire spring
    x0r = [(offset(i));x0_r];
    plot(x0t(1),x0t(2),'ko','MarkerSize',wheelSize,'MarkerFaceColor','k')
    
    % Plot suspension spring
    x0s = [(-w5/2 + offset(i));x0_s];
    u = L2/9;
    x1s = x0s + [0;u];
    x2s = x0s + [-w4/2;3/2*u];
    x3s = x2s + [w4;u];
    x4s = x3s + [-w4;u];
    x5s = x4s + [w4;u];
    x6s = x5s + [-w4;u];
    x7s = x6s + [w4;u];
    x8s = x7s + [-w4;u];
    x9s = x8s + [w4/2;u/2];
    x10s = x9s + [0;u];
    plot([x0s(1) x1s(1) x2s(1) x3s(1) x4s(1) x5s(1) ...
        x6s(1) x7s(1) x8s(1) x9s(1) x10s(1)], ...
        [x0s(2) x1s(2) x2s(2) x3s(2) x4s(2) x5s(2) ...
        x6s(2) x7s(2) x8s(2) x9s(2) x10s(2)], 'k-','LineWidth',3)
    
    % Plot suspension damper
    x0d = [(w5/2 + offset(i));x0_s];
    a = 0.7*(h2-h1-h3/2-h4/2); b = L2-a; c = 0.3*w4;
    x1d = x0d + [-c;a];
    x2d = x0d + [-c;0];
    x3d = x0d + [c;0];
    x4d = x0d + [c;a];
    x5d = x0d + [-c;b];
    x6d = x0d + [c;b];
    x7d = x0d + [0;L2];
    x8d = x0d + [0;b];
    plot([x1d(1) x2d(1) x3d(1) x4d(1)], ...
        [x1d(2) x2d(2) x3d(2) x4d(2)], 'k-','LineWidth',2);
    plot([x5d(1) x6d(1)],[x5d(2) x6d(2)], 'k-','LineWidth',4);
    plot([x7d(1) x8d(1)],[x7d(2) x8d(2)],'k-','LineWidth',2);
end