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

A = [0 n 0; 0 -b/J K_tau/J; 0 -K_m/L_m -R_m/L_m];
B = [0; 0; 1/L_m];
C = [1 0 0];
D = 0;


l_1 = 119;
l_2 = 4;
l_3 = 1;
L = [l_1, l_2, l_3]
l_0 = l_1;

% Create state-space system
sys_open = ss(A, B, C, D);

A_cl = A - B*L;

sys_cl = ss(A_cl, B*l_0, C, D);

poles = pole(sys_cl);
eigenvalues = eig(A_cl)

%{%}
t = 0:0.01:250;  % Simulation time vector
[y_cl, t, x_cl] = step(sys_cl, t);  % Step response of the closed-loop system

% Initialize control input vector
u = zeros(length(t), 1);  % Pre-allocate for control input

% Reference input (unit step input)
r = ones(size(t));  % Reference signal (unit step)

% Compute control input u(t) at each time step
for k = 1:length(t)
    % Compute control input u(t) = r * l_0 - L * x(t)
    u(k) = r(k) * l_0 - L * x_cl(k, :)';  % x_cl contains states at each time step
end

% Plot the step response (output)
figure;
subplot(2,1,1);
plot(t, y_cl);
title('Step Response of the Closed-Loop System');
xlabel('Time (seconds)');
ylabel('Output y(t)');
grid on;

% Plot the control input u(t)
subplot(2,1,2);
plot(t, u);
title('Control Input u(t) Over Time');
xlabel('Time (seconds)');
ylabel('Control Input u(t)');
grid on;


lab3robot(G,K_p,F,A,B,C,L,l_0,040110);
