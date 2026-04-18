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

% Stagnation Point Trajectory Analysis
fprintf('\n=== Stagnation Point Trajectory Analysis ===\n');
plot_stagnation_trajectory(a, v_0, 3);

% Flow with circulation
fprintf('\n=== Flow with circulation ===\n');
plot_cylinder_flow(X, Y, a, v_0, mu, 5);

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
    
    %% Compute Singularities
    % Singularities occur where the complex potential W(z) is undefined
    % For W(z) = v_0(z + a^2/z) - i*mu/z:
    % - Singularity at z = 0 from the 1/z terms (doublet and circulation)
    x_sing = [0];
    y_sing = [0];
    
    % Filter singularities outside the cylinder
    sing_outside = sqrt(x_sing.^2 + y_sing.^2) >= a;
    x_sing = x_sing(sing_outside);
    y_sing = y_sing(sing_outside);
    
    %% Compute Stagnation Points
    % Stagnation points occur where dW/dz = 0
    % dW/dz = v_0(1 - a^2/z^2) + i*mu/z^2 = 0
    % Solving: z^2 = a^2 - i*mu/v_0
    z_squared = a^2 - 1i*mu/v_0;
    z_stag = [sqrt(z_squared); -sqrt(z_squared)];
    x_stag = real(z_stag);
    y_stag = imag(z_stag);
    
    % Filter stagnation points outside the cylinder
    stag_outside = sqrt(x_stag.^2 + y_stag.^2) >= a;
    x_stag = x_stag(stag_outside);
    y_stag = y_stag(stag_outside);
    
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
    
    % Plot singularities
    if ~isempty(x_sing)
        plot(x_sing, y_sing, 'x', 'MarkerSize', 14, 'Color', [0, 0.4, 0.8], 'LineWidth', 3);
    end
    
    % Plot stagnation points
    if ~isempty(x_stag)
        plot(x_stag, y_stag, 'o', 'MarkerSize', 12, 'MarkerFaceColor', [0.5, 0, 0.13], 'MarkerEdgeColor', [0.5, 0, 0.13], 'LineWidth', 2);
        % Label stagnation points
        for i = 1:length(x_stag)
            text(x_stag(i), y_stag(i) + 0.25, sprintf('Stag (%.2f, %.2f)', x_stag(i), y_stag(i)), ...
                'HorizontalAlignment', 'center', 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', 'w');
        end
    end
    
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
    
    if ~isempty(x_stag) && ~isempty(x_sing)
        legend('Streamlines (\psi)', 'Equipotential lines (\phi)', 'Cylinder', 'Singularities', 'Stagnation points', 'Location', 'southwest');
    elseif ~isempty(x_sing)
        legend('Streamlines (\psi)', 'Equipotential lines (\phi)', 'Cylinder', 'Singularities', 'Location', 'southwest');
    elseif ~isempty(x_stag)
        legend('Streamlines (\psi)', 'Equipotential lines (\phi)', 'Cylinder', 'Stagnation points', 'Location', 'southwest');
    else
        legend('Streamlines (\psi)', 'Equipotential lines (\phi)', 'Cylinder', 'Location', 'southwest');
    end
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
    set(gcf, 'Position', [100, 100, 800, 700]);
    
    % % Streamlines with velocity field
    % subplot(1, 2, 1)
    % hold on;
    % contour(X, Y, psi, 30, 'm');  % Streamlines
    % % Subsample grid for quiver plot
    % skip = 15;
    % quiver(X(1:skip:end, 1:skip:end), Y(1:skip:end, 1:skip:end), ...
    %        u(1:skip:end, 1:skip:end), v(1:skip:end, 1:skip:end), 1.5, 'k');
    % fill(x_cyl, y_cyl, [0.8, 0.8, 0.8]);
    % plot(x_cyl, y_cyl, 'k-', 'LineWidth', 2);
    % axis equal;
    % xlim([-3, 3]);
    % ylim([-3, 3]);
    % xlabel('Real(z)');
    % ylabel('Imag(z)');
    % title('Streamlines with Velocity Vectors');
    % hold off;
    
    % Velocity magnitude
    hold on;
    contourf(X, Y, vel_mag, 20, 'LineStyle', 'none');
    colorbar;
    fill(x_cyl, y_cyl, [0.5, 0.5, 0.5]);
    h_cyl = plot(x_cyl, y_cyl, 'k-', 'LineWidth', 2);
    
    % Plot singularities on velocity magnitude plot
    if ~isempty(x_sing)
        h_sing = plot(x_sing, y_sing, 'x', 'MarkerSize', 14, 'Color', [0, 0.4, 0.8], 'LineWidth', 3);
    end
    
    % Plot stagnation points on velocity magnitude plot
    if ~isempty(x_stag) && ~isempty(x_sing)
        h_stag = plot(x_stag, y_stag, 'o', 'MarkerSize', 12, 'MarkerFaceColor', [0.5, 0, 0.13], 'MarkerEdgeColor', [0.5, 0, 0.13], 'LineWidth', 2);
        legend([h_cyl, h_sing, h_stag], {'Cylinder', 'Singularities', 'Stagnation Points'}, 'Location', 'southwest');
    elseif ~isempty(x_sing)
        legend([h_cyl, h_sing], {'Cylinder', 'Singularities'}, 'Location', 'southwest');
    elseif ~isempty(x_stag)
        h_stag = plot(x_stag, y_stag, 'o', 'MarkerSize', 12, 'MarkerFaceColor', [0.5, 0, 0.13], 'MarkerEdgeColor', [0.5, 0, 0.13], 'LineWidth', 2);
        legend([h_cyl, h_stag], {'Cylinder', 'Stagnation Points'}, 'Location', 'southwest');
    else
        legend(h_cyl, 'Cylinder', 'Location', 'southwest');
    end
    
    axis equal;
    xlim([-3, 3]);
    ylim([-3, 3]);
    xlabel('Real(z)');
    ylabel('Imag(z)');
    
    if mu == 0
        title('Velocity Magnitude |V| - Flow Around Cylinder');
    else
        title('Velocity Magnitude |V| - Flow with Circulation');
    end
    hold off;
    
    %% Print Analysis
    fprintf('Cylinder radius: a = %.2f\n', a);
    fprintf('Free stream velocity: v_0 = %.2f\n', v_0);
    fprintf('Circulation parameter: mu = %.2f\n', mu);
    
    if ~isempty(x_sing)
        fprintf('Singularities:\n');
        for i = 1:length(x_sing)
            fprintf('  z_%d = %.4f + %.4fi\n', i, x_sing(i), y_sing(i));
        end
    end
    
    if ~isempty(x_stag)
        fprintf('Stagnation points:\n');
        for i = 1:length(x_stag)
            fprintf('  z_%d = %.4f + %.4fi (r = %.4f)\n', i, x_stag(i), y_stag(i), sqrt(x_stag(i)^2 + y_stag(i)^2));
        end
    else
        fprintf('No stagnation points outside cylinder\n');
    end
    
    if mu == 0
        fprintf('Maximum velocity on surface: |V_max| = 2*v_0 = %.2f (at top/bottom)\n', 2*v_0);
    else
        fprintf('Note: Circulation breaks symmetry and shifts stagnation points\n');
    end
end

function plot_stagnation_trajectory(a, v_0, fig_num)
    % Plot trajectory of stagnation points as circulation parameter mu varies
    % Inputs:
    %   a - cylinder radius
    %   v_0 - free stream velocity
    %   fig_num - figure number
    
    % Range of mu values to explore
    mu_values = linspace(0, 4*v_0*a, 200);
    
    % Storage for stagnation point trajectories
    % Two branches: positive and negative sqrt
    stag_pos_x = zeros(size(mu_values));
    stag_pos_y = zeros(size(mu_values));
    stag_neg_x = zeros(size(mu_values));
    stag_neg_y = zeros(size(mu_values));
    
    % Compute stagnation points for each mu
    for i = 1:length(mu_values)
        mu = mu_values(i);
        % Stagnation points: z^2 = a^2 - i*mu/v_0
        z_squared = a^2 - 1i*mu/v_0;
        z_pos = sqrt(z_squared);
        z_neg = -sqrt(z_squared);
        
        stag_pos_x(i) = real(z_pos);
        stag_pos_y(i) = imag(z_pos);
        stag_neg_x(i) = real(z_neg);
        stag_neg_y(i) = imag(z_neg);
    end
    
    % Create figure
    figure(fig_num)
    set(gcf, 'Position', [100, 100, 800, 700]);
    hold on;
    
    % Draw cylinder
    theta_cyl = linspace(0, 2*pi, 100);
    x_cyl = a * cos(theta_cyl);
    y_cyl = a * sin(theta_cyl);
    fill(x_cyl, y_cyl, [0.8, 0.8, 0.8]);
    plot(x_cyl, y_cyl, 'k-', 'LineWidth', 2);
    
    % Plot trajectories
    h1 = plot(stag_pos_x, stag_pos_y, 'r-', 'LineWidth', 2);
    h2 = plot(stag_neg_x, stag_neg_y, 'b-', 'LineWidth', 2);
    
    % Mark specific mu values
    mu_markers = [0, v_0*a, 2*v_0*a, 3*v_0*a, 4*v_0*a];
    for mu_mark = mu_markers
        [~, idx] = min(abs(mu_values - mu_mark));
        plot(stag_pos_x(idx), stag_pos_y(idx), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
        plot(stag_neg_x(idx), stag_neg_y(idx), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
        
        % Label only non-zero mu values
        if mu_mark > 0
            text(stag_pos_x(idx) + 0.15, stag_pos_y(idx), sprintf('\\mu=%.1f', mu_mark), ...
                'FontSize', 9, 'Color', 'r');
            text(stag_neg_x(idx) - 0.15, stag_neg_y(idx), sprintf('\\mu=%.1f', mu_mark), ...
                'FontSize', 9, 'Color', 'b', 'HorizontalAlignment', 'right');
        end
    end
    
    % Mark initial position (mu = 0)
    plot(a, 0, 'ko', 'MarkerSize', 12, 'MarkerFaceColor', 'k');
    plot(-a, 0, 'ko', 'MarkerSize', 12, 'MarkerFaceColor', 'k');
    text(a + 0.15, 0, '\mu=0', 'FontSize', 9, 'Color', 'k');
    
    axis equal;
    xlim([-3, 3]);
    ylim([-3, 3]);
    xlabel('Real(z)');
    ylabel('Imag(z)');
    title(sprintf('Stagnation Point Trajectories as \\mu varies (0 to %.1f)', max(mu_values)));
    legend([h1, h2], {'Branch 1: +sqrt', 'Branch 2: -sqrt'}, 'Location', 'southwest');
    grid on;
    hold off;
    
    fprintf('Stagnation point trajectory computed for mu in [0, %.2f]\n', max(mu_values));
    fprintf('At mu = 0: stagnation points at z = +/-%.2f (on real axis)\n', a);
    fprintf('As mu increases: points move off real axis in complex plane\n');
    fprintf('Critical mu = %.2f: stagnation points merge at origin\n', 2*v_0*a);
end