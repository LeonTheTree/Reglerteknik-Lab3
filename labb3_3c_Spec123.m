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

% Controller parameters
beta = 0.16;
tau_d = 2.5;
tau_i = 10;
K = 17.278;
gamma = 0;

% F = K
F = K*(tau_d*s + 1)*(tau_i*s + 1)/((beta*tau_d*s + 1)*(tau_i*s + gamma));

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

%{
[GM, PM, Wcg, Wcp] = margin(open_loop);
fprintf('Open-Loop Gain Margin (GM): %.2f dB\n', 20*log10(GM));
fprintf('Open-Loop Phase Margin (PM): %.2f degrees\n', PM);
fprintf('Open-Loop phase Crossover Frequency (Wcg): %.2f rad/s\n', Wcg);
fprintf('Open-Loop gain Crossover Frequency (Wcp): %.2f rad/s\n', Wcp);
%}

closed_loop = feedback(open_loop, 1);  

% Bode plot for closed-loop system
figure;
bode(closed_loop);
grid on;
title('Closed-Loop Bode Plot');



% Simulate the closed-loop step response
t = 0:0.01:20;  % Time vector
r = ones(size(t));  % Unit step input

% Simulate the system response (y is the output of the closed-loop system)
y = lsim(closed_loop, r, t);

% The control signal u(t) is the output of the compensator F(s) to the error signal
error_signal = r(:) - y(:);  % Error signal = r(t) - y(t)

% Ensure error_signal is a column vector for correct input format
u = lsim(F, error_signal, t);  % Control signal u(t)

% Plot the control signal u(t)
figure;
plot(t, u);
xlabel('Time (s)');
ylabel('Control Signal u(t)');
title('Control Signal u(t) for Unit Step Input');
grid on;