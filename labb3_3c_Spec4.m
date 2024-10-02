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
tau_i = 10; % 12.4
K = 17.278;
gamma = 0; % 0.038


F = K*(tau_d*s + 1)*(tau_i*s + 1)/((beta*tau_d*s + 1)*(tau_i*s + gamma));

open_loop = F * G;
closed_loop = feedback(open_loop, 1);  


% Define time vector and unit ramp input
t = 0:0.01:100;  % Time vector from 0 to 50 seconds
r_ramp = t;  % Unit ramp input

% Simulate the system response to the ramp input
y_ramp = lsim(closed_loop, r_ramp, t);

% Calculate the steady-state error
error_ramp = r_ramp(:) - y_ramp(:);


% Plot the ramp response and error
figure;
plot(t, r_ramp, '--', t, y_ramp, 'LineWidth', 1.5);
legend('Reference (ramp input)', 'System Output');
xlabel('Time (s)');
ylabel('Output');
title('System Response to Unit Ramp Input');
grid on;

figure;
plot(t, error_ramp, 'r', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Error');
title('Error Response to Unit Ramp Input');
grid on;


