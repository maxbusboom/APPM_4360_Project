% Elementary Flow Visualization in the Complex Plane
% Complex Potential Analysis: W(z) = k*log(z-a)
% Author: Generated for fluid dynamics visualization
% Date: April 15, 2026

clc; clear; close all;

%% Setup Grid
x = linspace(-3, 3, 400);
y = linspace(-3, 3, 400);
[X, Y] = meshgrid(x, y);

%% Parameters
% Position of source/sink/vortex in complex plane
a = 0.5 + 0.3i;  % Complex constant position
a_x = real(a);
a_y = imag(a);

% Distance from singularity point
r = sqrt((X - a_x).^2 + (Y - a_y).^2);
theta = atan2(Y - a_y, X - a_x);

% Avoid singularity at z = a
r(r < 0.1) = NaN;

%% Source Flow (k > 0)
k_source = 2;  % Positive k for source

% Complex potential: W(z) = k*log(z-a) = k*log(r) + i*k*theta
% Real part (velocity potential): phi = k*log(r)
% Imaginary part (stream function): psi = k*theta
phi_source = k_source * log(r);
psi_source = k_source * theta;

figure(1)
set(gcf, 'Position', [100, 100, 800, 700]);
hold on;
contour(X, Y, psi_source, 30, 'm');  % Streamlines (magenta)
contour(X, Y, phi_source, 30, 'b--');  % Equipotential lines (blue dashed)
plot(a_x, a_y, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
axis equal;
xlim([-3, 3]);
ylim([-3, 3]);
xlabel('Real(z)');
ylabel('Imag(z)');
title(['Source Flow: W(z) = k·log(z-a), k = ' num2str(k_source) ' > 0']);
legend('Streamlines (\psi)', 'Equipotential lines (\phi)', 'Source location', 'Location', 'best');
hold off;

%% Sink Flow (k < 0)
k_sink = -2;  % Negative k for sink

phi_sink = k_sink * log(r);
psi_sink = k_sink * theta;

figure(2)
set(gcf, 'Position', [100, 100, 800, 700]);
hold on;
contour(X, Y, psi_sink, 30, 'm');  % Streamlines (magenta)
contour(X, Y, phi_sink, 30, 'b--');  % Equipotential lines (blue dashed)
plot(a_x, a_y, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
axis equal;
xlim([-3, 3]);
ylim([-3, 3]);
xlabel('Real(z)');
ylabel('Imag(z)');
title(['Sink Flow: W(z) = k·log(z-a), k = ' num2str(k_sink) ' < 0']);
legend('Streamlines (\psi)', 'Equipotential lines (\phi)', 'Sink location', 'Location', 'best');
hold off;

%% Vortex Flow (i*k*log(z-a))
k_vortex = 2;  % Strength parameter

% Complex potential: W(z) = i*k*log(z-a) = i*k*(log(r) + i*theta)
%                          = i*k*log(r) - k*theta
% Real part (velocity potential): phi = -k*theta
% Imaginary part (stream function): psi = k*log(r)
phi_vortex = -k_vortex * theta;
psi_vortex = k_vortex * log(r);

figure(3)
set(gcf, 'Position', [100, 100, 800, 700]);
hold on;
contour(X, Y, psi_vortex, 30, 'm');  % Streamlines (magenta)
contour(X, Y, phi_vortex, 30, 'b--');  % Equipotential lines (blue dashed)
plot(a_x, a_y, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
axis equal;
xlim([-3, 3]);
ylim([-3, 3]);
xlabel('Real(z)');
ylabel('Imag(z)');
title(['Vortex Flow: W(z) = i·k·log(z-a), k = ' num2str(k_vortex)]);
legend('Streamlines (\psi)', 'Equipotential lines (\phi)', 'Vortex center', 'Location', 'best');
hold off;

%% Doublet Flow (W(z) = mu/z)
% For doublet at origin with real strength mu
mu = 2;  % Real doublet strength (purely real for streamline on real axis)
a_doublet = 0;  % Doublet at origin

% Calculate distances from doublet center (origin)
r_doublet = sqrt(X.^2 + Y.^2);
r_doublet(r_doublet < 0.1) = NaN;  % Avoid singularity

% Complex potential: W(z) = mu/z = mu/(x+iy) = mu*(x-iy)/(x^2+y^2)
% Real part (velocity potential): phi = mu*x/(x^2+y^2)
% Imaginary part (stream function): psi = -mu*y/(x^2+y^2)
% Note: psi = 0 when y = 0 (the real axis is a streamline!)
phi_doublet = mu * X ./ (r_doublet.^2);
psi_doublet = -mu * Y ./ (r_doublet.^2);

figure(4)
set(gcf, 'Position', [100, 100, 800, 700]);
hold on;
contour(X, Y, psi_doublet, 30, 'm');  % Streamlines (magenta)
contour(X, Y, phi_doublet, 30, 'b--');  % Equipotental lines (blue dashed)
plot(0, 0, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
%plot([-3, 3], [0, 0], 'm-', 'LineWidth', 2);  % Real axis streamline
axis equal;
xlim([-3, 3]);
ylim([-3, 3]);
xlabel('Real(z)');
ylabel('Imag(z)');
title(['Doublet Flow: W(z) = \mu/z, \mu = ' num2str(mu)]);
legend('Streamlines (\psi)', 'Equipotential lines (\phi)', 'Doublet at origin', 'Real axis (\psi=0)', 'Location', 'best');
hold off;

%% Combined Comparison Plot
figure(5)
set(gcf, 'Position', [100, 100, 1400, 1000]);
subplot(2, 2, 1)
hold on;
contour(X, Y, psi_source, 30, 'm');
contour(X, Y, phi_source, 30, 'b--');
plot(a_x, a_y, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
axis equal;
xlim([-3, 3]); ylim([-3, 3]);
xlabel('Real(z)'); ylabel('Imag(z)');
title('Source (k > 0)');
hold off;

subplot(2, 2, 2)
hold on;
contour(X, Y, psi_sink, 30, 'm');
contour(X, Y, phi_sink, 30, 'b--');
plot(a_x, a_y, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
axis equal;
xlim([-3, 3]); ylim([-3, 3]);
xlabel('Real(z)'); ylabel('Imag(z)');
title('Sink (k < 0)');
hold off;

subplot(2, 2, 3)
hold on;
contour(X, Y, psi_vortex, 30, 'm');
contour(X, Y, phi_vortex, 30, 'b--');
plot(a_x, a_y, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
axis equal;
xlim([-3, 3]); ylim([-3, 3]);
xlabel('Real(z)'); ylabel('Imag(z)');
title('Vortex (i·k)');
hold off;

subplot(2, 2, 4)
hold on;
contour(X, Y, psi_doublet, 30, 'm');
contour(X, Y, phi_doublet, 30, 'b--');
plot(0, 0, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
%plot([-3, 3], [0, 0], 'm-', 'LineWidth', 1.5);  % Real axis streamline
axis equal;
xlim([-3, 3]); ylim([-3, 3]);
xlabel('Real(z)'); ylabel('Imag(z)');
title('Doublet (\mu/z)');
hold off;

% Add global legend for the comparison plot
Lh = legend('Streamlines (\psi)', 'Equipotential lines (\phi)', 'Singularity');
Lh.Position(1) = 0.45;  % Center horizontally
Lh.Position(2) = 0.02;  % Bottom of figure

sgtitle('Elementary Flows in the Complex Plane');

fprintf('Plots generated successfully!\n');
fprintf('Source/Sink/Vortex location: a = %.2f + %.2fi\n', a_x, a_y);
fprintf('Doublet location: origin (0, 0)\n');
fprintf('Source strength: k = %.2f\n', k_source);
fprintf('Sink strength: k = %.2f\n', k_sink);
fprintf('Vortex circulation: Γ = 2πk = %.2f\n', 2*pi*k_vortex);
fprintf('Doublet strength: μ = %.2f (real axis is streamline)\n', mu);
