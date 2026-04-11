% Kaitlyn Vigil
% Assignmnet #4
% 2/10/2025

clc; clear; close all;


%% Problem 3
x = linspace(-4,4,400);
y = linspace(-4,4,400);

r = sqrt(x.^2+y.^2);
theta = atan2(y,x);

c_p = -2.*cos(theta)./r - 1./(r.^2);

figure(3)
plot(x, c_p, "m")
xlabel("Centerline Body Distance")
ylabel("Pressure Coefficient Distribution")
title(" Problem 3: Pressure Coefficient Distribution Over the Body")


%% Problem 6]
% Grid
[X,Y] = meshgrid(x,y);

% Variables
v_inf = 1;
gamma = 4; 

theta1 = atan2(Y-1, X);
theta2 = atan2(Y+1, X);

r1 = sqrt(X.^2 + (Y-1).^2);
r2 = sqrt(X.^2 + (Y+1).^2);

% Streamline function (x,y)
phi = X*v_inf + (gamma/(2*pi))*theta1 - (gamma/(2*pi))*theta2;

% Equipotential functin (x,y)
psi = Y*v_inf - (gamma/(2*pi))*log(r1) + gamma/(2*pi)*log(r2);

figure(6)
hold on;
contour(X, Y, psi, 30, "m")
contour(X, Y, phi, 30, "b--")
axis equal;
xlim([-4,4]);
ylim([-4,4]);

