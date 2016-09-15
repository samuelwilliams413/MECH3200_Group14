function [] = main()

clear all
close all
vehicle_suspension_model
data = sim('vehicle_suspension_model','SimulationMode','normal');
close all
H = data.get('H');
dis_F = data.get('dis_F');
dis_R = data.get('dis_R');
T = data.get('T_out');
Td = data.get('Td_out');
Tdd = data.get('Tdd_out');
Z = data.get('Z_out');
Zd = data.get('Zd_out');
Zdd = data.get('Zdd_out');

hold off
hold on
r = 4;
c = 1;
a = [6.75 8 -0.14 -0.10];

subplot(r, c, 1);
plot(H)
title('Road Height');

subplot(r, c, 2);
plot(dis_F)
title('Wheel Front Height');
axis(a);

subplot(r, c, 3);
plot(dis_R)
title('Wheel Rear Height');
axis(a);

subplot(r, c, 4);
plot(T)
title('Car axis Height');


end