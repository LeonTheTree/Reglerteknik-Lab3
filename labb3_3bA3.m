% Pers. num.: 040110
s = tf('s');
L_m = 2;       
R_m = 21;      
b = 1;        
J = 3.5;
K_tau = 38;   
K_m = 0.5;     
n = 1/20;      


G_partial = K_tau / ((s * L_m + R_m) * (J * s + b));

G_0 = G_partial * n / s;

G = G_0 / (1 + G_partial * K_m);

K = 5.8;  %228
F = K;

open_loop = F * G;

% Bode plot for system
figure;
bode(G);
grid on;
title('System Bode Plot');

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

closed_loop = feedback(open_loop, 1);  

% Bode plot for closed-loop system
figure;
bode(closed_loop);
grid on;
title('Closed-Loop Bode Plot');
