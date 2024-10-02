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

K = 5.8;  
F = K;

T = feedback(F * G, 1);

% Step response to check overshoot and rise time
step(T);
grid on;

% Display characteristics such as rise time and overshoot
S = stepinfo(T);
overshoot = S.Overshoot
rise_time = S.RiseTime