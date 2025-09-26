clear,clc,close('all')

b = 5*12*0.0254; %ft to m
v_inf = 50/2.237; %mph to m/s
mass = 30*4.4482216153/9.81; %lbs to kg
c = 8*0.0254; % m
alpha = 10*pi/180; %AoA (rad)
a0 = 2*pi; %/radian
alpha_L0 = -2*pi/180;



numElements = 200;

[y_span, L_prime, L_total, CL] = Lift_Distr(b, c, alpha, a0, alpha_L0, v_inf);


tic
[maxG] = maxG_MDAO_updated(L_prime,b);
time = toc

plot(y_span, L_prime, 'or')
yline = 0;

[turnRadius, bankAngle] = turnRadius_MDAO(v_inf, maxG)