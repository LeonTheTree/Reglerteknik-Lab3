s = tf('s');

% System parameters
L_m = 2;       
R_m = 21;      
b = 1;        
J = 3.5;
K_tau = 38;   
K_m = 0.5;     
n = 1/20;      

% Define G
G_partial = K_tau / ((s * L_m + R_m) * (J * s + b));
G_0 = G_partial * n / s;
G = G_0 / (1 + G_partial * K_m);

K_p = 5.8;
% Controller parameters
beta = 0.16;
tau_d = 2.5;
tau_i = 12.4;
K = 17.278;
gamma = 0.038;


F = K*(tau_d*s + 1)*(tau_i*s + 1)/((beta*tau_d*s + 1)*(tau_i*s + gamma));

open_loop = F * G;
closed_loop = feedback(open_loop, 1); 

lab3robot(G,K_p,F,[],[],[],[],[],040110);


% Bode plot for open-loop system
figure;
bode(open_loop);
grid on;
title('Open-Loop Bode Plot');


[GM, PM, Wcg, Wcp] = margin(open_loop);
fprintf('Open-Loop Gain Margin (GM): %.2f dB\n', 20*log10(GM));
fprintf('Open-Loop Phase Margin (PM): %.2f degrees\n', PM);
fprintf('Open-Loop phase Crossover Frequency (Wcg): %.2f rad/s\n', Wcg);
fprintf('Open-Loop gain Crossover Frequency (Wcp): %.2f rad/s\n', Wcp);


% Bode plot for sensitivity functions

S_K_p = 1/(1 + G*K_p);
S_F = 1/(1 + G*F);

figure;
bodemag(S_K_p, S_F);
grid on;
title('Sensitivity magnitude Bode Plots');