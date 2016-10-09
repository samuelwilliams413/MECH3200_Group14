function [] = wheel_plot(x0_t,x0_r,w5,x0_s,L2,w4,h2,h1,h3,h4, offset)    
% Plot unsprung mass block
    x0t = [(offset);x0_t];

    wheelSize = 75;
    % Plot tire spring
    x0r = [(offset);x0_r];
    plot(x0t(1),x0t(2),'ko','MarkerSize',wheelSize,'MarkerFaceColor','k')
    
    % Plot suspension spring
    x0s = [(-w5/2 + offset);x0_s];
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
    x0d = [(w5/2 + offset);x0_s];
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