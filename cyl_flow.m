% Flow Around a Cylinder - Complex Potential Visualization
% Complex Potential: W(z) = v_0(z + a^2/z) and with circulation
% Author: Generated for fluid dynamics visualization
% Date: April 16, 2026

clc; clear; close all;

%% Parameters
a = 1;  % Cylinder radius
v_0 = 1;  % Free stream velocity
mu = 2;  % Circulation parameter

%% Setup Grid
x = linspace(-3, 3, 400);
y = linspace(-3, 3, 400);
[X, Y] = meshgrid(x, y);

%% Generate Plots

% Flow without circulation
fprintf('=== Flow without circulation ===\n');
plot_cylinder_flow(X, Y, a, v_0, 0, 1);

% Flow with circulation
fprintf('\n=== Flow with circulation ===\n');
plot_cylinder_flow(X, Y, a, v_0, mu, 3);

%% Function Definitions

function plot_cylinder_flow(X, Y, a, v_0, mu, fig_start)
    % Plot flow around cylinder with optional circulation term
    % Inputs:
    %   X, Y - meshgrid coordinates
    %   a - cylinder radius
    %   v_0 - free stream velocity
    %   mu - circulation parameter (0 for no circulation)
    %   fig_start - starting figure number
    
    % Distance from origin
    r = sqrt(X.^2 + Y.^2);
    
    % Mask points inside the cylinder
    inside_cylinder = (r < a);
    
    %% Complex Potential: W(z) = v_0(z + a^2/z) - i*mu/z
    % Without circulation (mu = 0): W(z) = v_0(z + a^2/z)
    % With circulation (mu ≠ 0): W(z) = v_0(z + a^2/z) - i*mu/z
    %
    % Real part (velocity potential): phi = v_0(x + a^2*x/r^2) + mu*y/r^2
    % Imaginary part (stream function): psi = v_0(y - a^2*y/r^2) - mu*x/r^2
    
    r2 = r.^2;
    phi = v_0 * (X + a^2 * X ./ r2) + mu * Y ./ r2;
    psi = v_0 * (Y - a^2 * Y ./ r2) - mu * X ./ r2;
    
    % Set interior points to NaN to avoid plotting inside cylinder
    phi(inside_cylinder) = NaN;
    psi(inside_cylinder) = NaN;
    
    %% Figure 1: Streamlines and Equipotential Lines
    figure(fig_start)
    set(gcf, 'Position', [100, 100, 800, 700]);
    hold on;
    contour(X, Y, psi, 30, 'm');  % Streamlines (magenta)
    contour(X, Y, phi, 30, 'b--');  % Equipotential lines (blue dashed)
    
    % Draw the cylinder
    theta_cyl = linspace(0, 2*pi, 100);
    x_cyl = a * cos(theta_cyl);
    y_cyl = a * sin(theta_cyl);
    fill(x_cyl, y_cyl, [0.8, 0.8, 0.8]);  % Gray filled cylinder
    plot(x_cyl, y_cyl, 'k-', 'LineWidth', 2);  % Cylinder boundary
    
    axis equal;
    xlim([-3, 3]);
    ylim([-3, 3]);
    xlabel('Real(z)');
    ylabel('Imag(z)');
    
    if mu == 0
        title(['Flow Around Cylinder: W(z) = v_0(z + a^2/z), a = ' num2str(a) ', v_0 = ' num2str(v_0)]);
    else
        title(['Flow with Circulation: W(z) = v_0(z + a^2/z) - i\mu/z, \mu = ' num2str(mu)]);
    end
    
    legend('Streamlines (\psi)', 'Equipotential lines (\phi)', 'Cylinder', 'Location', 'best');
    hold off;
    
    %% Calculate velocity field
    % Velocity: dW/dz = v_0(1 - a^2/z^2) - i*mu*(-1/z^2) = v_0(1 - a^2/z^2) + i*mu/z^2
    % u - iv = v_0(1 - a^2*(x - iy)^2/r^4) + i*mu*(x - iy)^2/r^4
    %        = v_0(1 - a^2*(x^2 - y^2 - 2ixy)/r^4) + i*mu*(x^2 - y^2 - 2ixy)/r^4
    % u = v_0(1 - a^2*(x^2 - y^2)/r^4) - 2*mu*x*y/r^4
    % v = v_0(2*a^2*x*y/r^4) + mu*(x^2 - y^2)/r^4
    
    r4 = r2.^2;
    u = v_0 * (1 - a^2 * (X.^2 - Y.^2) ./ r4) - 2*mu * X .* Y ./ r4;
    v = v_0 * (2 * a^2 * X .* Y ./ r4) + mu * (X.^2 - Y.^2) ./ r4;
    
    % Mask interior
    u(inside_cylinder) = NaN;
    v(inside_cylinder) = NaN;
    
    % Velocity magnitude
    vel_mag = sqrt(u.^2 + v.^2);
    
    %% Figure 2: Velocity Field Analysis
    figure(fig_start + 1)
    set(gcf, 'Position', [100, 100, 1200, 500]);
    
    % Streamlines with velocity field
    subplot(1, 2, 1)
    hold on;
    contour(X, Y, psi, 30, 'm');  % Streamlines
    % Subsample grid for quiver plot
    skip = 15;
    quiver(X(1:skip:end, 1:skip:end), Y(1:skip:end, 1:skip:end), ...
           u(1:skip:end, 1:skip:end), v(1:skip:end, 1:skip:end), 1.5, 'k');
    fill(x_cyl, y_cyl, [0.8, 0.8, 0.8]);
    plot(x_cyl, y_cyl, 'k-', 'LineWidth', 2);
    axis equal;
    xlim([-3, 3]);
    ylim([-3, 3]);
    xlabel('Real(z)');
    ylabel('Imag(z)');
    title('Streamlines with Velocity Vectors');
    hold off;
    
    % Velocity magnitude
    subplot(1, 2, 2)
    hold on;
    contourf(X, Y, vel_mag, 20, 'LineStyle', 'none');
    colorbar;
    fill(x_cyl, y_cyl, [0.5, 0.5, 0.5]);
    plot(x_cyl, y_cyl, 'k-', 'LineWidth', 2);
    axis equal;
    xlim([-3, 3]);
    ylim([-3, 3]);
    xlabel('Real(z)');
    ylabel('Imag(z)');
    title('Velocity Magnitude |V|');
    hold off;
    
    if mu == 0
        sgtitle('Flow Around Cylinder - Velocity Field Analysis');
    else
        sgtitle('Flow Around Cylinder with Circulation - Velocity Field Analysis');
    end
    
    %% Print Analysis
    fprintf('Cylinder radius: a = %.2f\n', a);
    fprintf('Free stream velocity: v_0 = %.2f\n', v_0);
    fprintf('Circulation parameter: mu = %.2f\n', mu);
    
    if mu == 0
        fprintf('Stagnation points: z = ±%.2f (at x = ±%.2f, y = 0)\n', a, a);
        fprintf('Maximum velocity on surface: |V_max| = 2*v_0 = %.2f (at top/bottom)\n', 2*v_0);
    else
        fprintf('Note: Circulation breaks symmetry and shifts stagnation points\n');
    end
end