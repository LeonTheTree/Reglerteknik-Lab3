% Pers. num.: 040110
% u_max = 120
s = tf('s');
L_m = 2;       
R_m = 21;      
b = 1;        
J = 3.5;
K_tau = 38;   
K_m = 0.5;     
n = 1/20;      


G_partial = K_tau / ((s * L_m + R_m) * (J * s + b));

% Full forward path transfer function
G_forward = G_partial * n / s;

% Closed-loop transfer function G(s) with feedback
G = G_forward / (1 + G_partial * K_m);

K = 5.8;

[J,umax] = lab3robot(040110)
%lab3robot(G,K,[],[],[],[],[],[],040110);