function plot_suspension(x,road_x,road_z,curr_x,umf,H)
% Vehicle positions:
z0 = x(1);          % road elevation
z1_front = x(2);
z1_rear = x(3);
z2 = x(4);          % sprung mass cm deviation
angle = x(5);
t = x(6);           % current time

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
x0_s_F = h1+z1_front+h3/2;  % suspension spring base position
x0_t_F = h1+z1_front-h3/2;  % unsprung mass block base position
x0_b = h2+z2-h4/2;  % spring mass block base position
L1_F = x0_t_F-x0_r;     % tire spring length
L2_F = x0_b-x0_s_F;     % suspension spring length

x0_r = z0;          % tire spring base position
x0_s_R = h1+z1_rear+h3/2;  % suspension spring base position
x0_t_R = h1+z1_rear-h3/2;  % unsprung mass block base position
x0_b = h2+z2-h4/2;  % spring mass block base position
L1_R = x0_t_R-x0_r;     % tire spring length
L2_R = x0_b-x0_s_R;     % suspension spring length


% Display current simulation time
text(fw/2,1.4,[num2str(t,'%2.1f') ' sec']);

% Plot road profile
% dx = road_x(2) - road_x(1);
% xstart = max([curr_x-fw,0]);
% [~,istart] = min(abs(xstart-road_x));
% xend = curr_x + fw;
% [~,iend] = min(abs(xend-road_x));
% xpstart = xstart-curr_x;
% xpend = fw;
% zp = road_z(istart:iend)*umf;
% xp = xpstart:dx:xpend;
% maxi = min([length(xp),length(zp)]);
figure(1);clf

frame = 100;
time = t/0.005;
if(time > frame)
    t1 = floor(time-frame);
    t2 = floor(time+frame);
    t1 = 50;
    t2 = 150;
    toPlot = 1000*H.data(t1:t2) + 0.13;
    plot(1:length(toPlot), toPlot);
end
% plot(xp(1:maxi),zp(1:maxi),'k-');
hold on
screenSize = 0.75;
axis([-1.5 1.5 -1.5  1.5]);

axis([-screenSize screenSize -0.25 1.5]);
offset = [-0.3,0.3];

l = abs(offset(1) - offset(2))/2;
% Plot sprung mass block
x0b = [0;x0_b];
x1b = x0b + [-w2/2;0];
x2b = x0b + [-w2/2;h4];
x3b = x0b + [w2/2;h4];
x4b = x0b + [w2/2;0];

x1b(1) = x1b(1) + offset(1);    %top left
x2b(1) = x2b(1) + offset(1);    %bottom left
x3b(1) = x3b(1) + offset(2);    %top right
x4b(1) = x4b(1) + offset(2);    %bottom right

% plot(0,x0b(2)  ,'rx')
% plot(0,x0b(2) + 0.5*h4  ,'gx')
% plot(0,x0b(2) - 0.5*h4  ,'gx')
% plot(offset(1),x0b(2)  ,'ro')
% plot(offset(2),x0b(2)  ,'ro')
cp=0.5*(x1b(2)+ x2b(2));
R = sqrt((x1b(1))^2 + (x1b(2)-cp)^2);
ax1b = atand((x1b(2) - cp)/x1b(1)) + 180 + angle;
ax2b = atand((x2b(2) - cp)/x2b(1)) + 180 + angle;
ax3b = atand((x3b(2) - cp)/x3b(1)) + angle;
ax4b = atand((x4b(2) - cp)/x4b(1)) + angle;

x1b(1) = R*cosd(ax1b);
x2b(1) = R*cosd(ax2b);
x3b(1) = R*cosd(ax3b);
x4b(1) = R*cosd(ax4b);

x1b(2) = cp + R*sind(ax1b);
x2b(2) = cp   + R*sind(ax2b);
x3b(2) = cp  +  R*sind(ax3b);
x4b(2) = cp   + R*sind(ax4b);





fill([x1b(1) x2b(1) x3b(1) x4b(1)],[x1b(2) x2b(2) x3b(2) x4b(2)], ...
    [65 105 225]/255)


wheel_plot(x0_t_F,x0_r,w5,x0_s_F,L2_F,w4,h2,h1,h3,h4, offset(1))
wheel_plot(x0_t_R,x0_r,w5,x0_s_R,L2_R,w4,h2,h1,h3,h4, offset(2))

end