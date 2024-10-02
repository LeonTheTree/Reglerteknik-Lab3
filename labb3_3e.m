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

G_open_loop = F * G;

% Complementary sensitivity function T(s)
T = G_open_loop / (1 + G_open_loop);

% Model error descriptions
DeltaG1 = (s + 10) / 40;
DeltaG2 = (s + 10) / (4 * (s + 0.01));

% 1 / DeltaG1 and 1 / DeltaG2
inv_DeltaG1 = 1 / DeltaG1;
inv_DeltaG2 = 1 / DeltaG2;

% Frequency response plot (Bode) for T(s) and 1/DeltaG(s)
figure;
bode(T, inv_DeltaG1, inv_DeltaG2);
legend('T(s)', '1/DeltaG1(s)', '1/DeltaG2(s)');
grid on;

% Checking stability condition:
% Robust stability condition: |T(jw)| < 1/|DeltaG(jw)|