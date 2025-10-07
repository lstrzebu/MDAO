clear,clc,close('all')

b = 5*12*0.0254; %ft to m
v_inf = 50/2.237; %mph to m/s
mass = 30*4.4482216153/9.81; %lbs to kg
c = 8*0.0254; % m
alpha = 10*pi/180; %AoA (rad)
a0 = 2*pi; % per radian
alpha_L0 = -2*pi/180;
N = 4; %number of fasteners
emptyWeight = 20*4.4482216153;
loadedWeight = 25*4.4482216153;

tic
[maxG,y_span,L_prime,minNumFasteners,minTurnRadius, maxBankAngle,~] = structures_MDAO(b, c, alpha, a0, alpha_L0, v_inf,emptyWeight, loadedWeight);
time = toc;







