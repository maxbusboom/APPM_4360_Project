% Flow Around a Cylinder - Complex Potential Visualization
% Complex Potential: W(z) = v_0(z + a^2/z) and with circulation
% Author: Max Busboom
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

%% Generate Plots (uncomment to visualize)

%Flow without circulation
%fprintf('=== Flow without circulation ===\n');
%plot_cylinder_flow(X, Y, a, v_0, 0, 1);

%Stagnation Point Trajectory Analysis
fprintf('\n=== Stagnation Point Trajectory Analysis ===\n');
plot_stagnation_trajectory(a, v_0, 3);

% Vortex Flow Stagnation Point Trajectory Analysis
fprintf('\n=== Vortex Flow Stagnation Point Trajectory Analysis ===\n');
plot_stagnation_trajectory_vortex(a, v_0, 4);

 %Flow with circulation
%fprintf('\n=== Flow with circulation ===\n');
%plot_cylinder_flow(X, Y, a, v_0, mu, 5);

% Flow with log circulation
fprintf('\n=== Flow with circulation (log formulation) ===\n');
plot_cylinder_flow(X, Y, a, v_0, 5, 7, 'cylinder_log');

%% Elementary Flows (uncomment to visualize)
% Doublet flow
% fprintf('\n=== Doublet Flow ===\n');
% plot_cylinder_flow(X, Y, a, 2, 0, 9, 'doublet');

% Vortex flow
%fprintf('\n=== Vortex Flow ===\n');
%plot_cylinder_flow(X, Y, a, v_0, 2, 11, 'vortex');

% Source flow
%fprintf('\n=== Source Flow ===\n');
%plot_cylinder_flow(X, Y, a, v_0, 1.5, 13, 'source');

% Sink flow
% fprintf('\n=== Sink Flow ===\n');
% plot_cylinder_flow(X, Y, a, v_0, -1.5, 15, 'source');

%% Function Definitions

function plot_cylinder_flow(X, Y, a, v_0, mu, fig_start, flow_type)
    % Plot flow around cylinder with optional circulation term
    % Inputs:
    %   X, Y - meshgrid coordinates
    %   a - cylinder radius
    %   v_0 - free stream velocity (or doublet strength for doublet flow)
    %   mu - circulation parameter (or source strength for source/vortex)
    %   fig_start - starting figure number
    %   flow_type - (optional) 'cylinder' (default), 'doublet', 'vortex', or 'source'
    
    % Set default flow type
    if nargin < 7
        flow_type = 'cylinder';
    end
    
    % Distance from origin
    r = sqrt(X.^2 + Y.^2);
    theta = atan2(Y, X);
    
    % Mask points inside the cylinder and near singularity
    inside_cylinder = (r < a);
    near_singularity = (r < 0.05);  % Small region around origin for elementary flows
    
    %% Complex Potential - depends on flow type
    r2 = r.^2;
    
    switch lower(flow_type)
        case 'cylinder'
            % Cylinder Flow with Circulation: W(z) = v_0(z + a^2/z) - i*mu/z
            % Real part (velocity potential): phi = v_0(x + a^2*x/r^2) + mu*y/r^2
            % Imaginary part (stream function): psi = v_0(y - a^2*y/r^2) - mu*x/r^2
            phi = v_0 * (X + a^2 * X ./ r2) + mu * Y ./ r2;
            psi = v_0 * (Y - a^2 * Y ./ r2) - mu * X ./ r2;
            phi(inside_cylinder) = NaN;
            psi(inside_cylinder) = NaN;
            
        case 'doublet'
            % Doublet Flow Around Cylinder: W(z) = v_0(z + a^2/z)
            % This is uniform flow + doublet (cylinder flow without circulation)
            % Real part: phi = v_0(x + a^2*x/r^2)
            % Imaginary part: psi = v_0(y - a^2*y/r^2)
            phi = v_0 * (X + a^2 * X ./ r2);
            psi = v_0 * (Y - a^2 * Y ./ r2);
            phi(inside_cylinder) = NaN;
            psi(inside_cylinder) = NaN;
            
        case 'vortex'
            % Vortex Flow Around Cylinder: W(z) = v_0(z + a^2/z) + i*mu*log(z/a)
            % Uniform flow + doublet + vortex
            % Real part: phi = v_0(x + a^2*x/r^2) - mu*theta
            % Imaginary part: psi = v_0(y - a^2*y/r^2) + mu*log(r/a)
            phi = v_0 * (X + a^2 * X ./ r2) - mu * theta;
            psi = v_0 * (Y - a^2 * Y ./ r2) + mu * log(r/a);
            phi(inside_cylinder) = NaN;
            psi(inside_cylinder) = NaN;
            
        case 'source'
            % Source Flow Around Cylinder: W(z) = v_0(z + a^2/z) + mu*log(z/a)
            % Uniform flow + doublet + source
            % Real part: phi = v_0(x + a^2*x/r^2) + mu*log(r/a)
            % Imaginary part: psi = v_0(y - a^2*y/r^2) + mu*theta
            phi = v_0 * (X + a^2 * X ./ r2) + mu * log(r/a);
            psi = v_0 * (Y - a^2 * Y ./ r2) + mu * theta;
            phi(inside_cylinder) = NaN;
            psi(inside_cylinder) = NaN;
            
        case 'cylinder_log'
            % Cylinder Flow with Log Circulation: W(z) = v_0(z + a^2/z) - i*mu*log(z)/(2*pi)
            % This uses the standard vortex formulation: -i*Gamma*log(z)/(2*pi)
            % Real part: phi = v_0(x + a^2*x/r^2) + mu*theta/(2*pi)
            % Imaginary part: psi = v_0(y - a^2*y/r^2) - mu*log(r)/(2*pi)
            phi = v_0 * (X + a^2 * X ./ r2) + mu * theta / (2*pi);
            psi = v_0 * (Y - a^2 * Y ./ r2) - mu * log(r) / (2*pi);
            phi(inside_cylinder) = NaN;
            psi(inside_cylinder) = NaN;
            
        otherwise
            error('Unknown flow_type: %s. Use ''cylinder'', ''doublet'', ''vortex'', ''source'', or ''cylinder_log''.', flow_type);
    end
    
    %% Compute Singularities
    % Singularities occur where the complex potential W(z) is undefined
    switch lower(flow_type)
        case 'cylinder'
            % For W(z) = v_0(z + a^2/z) - i*mu/z: singularity at z = 0 from 1/z terms
            x_sing = [0];
            y_sing = [0];
        case 'doublet'
            % For W(z) = mu_d/z: singularity at z = 0
            x_sing = [0];
            y_sing = [0];
        case {'vortex', 'source', 'cylinder_log'}
            % For W(z) = k*log(z): singularity at z = 0
            x_sing = [0];
            y_sing = [0];
    end
    
    % Filter singularities outside the cylinder (for all flow types)
    % Only plot singularities with r >= a
    sing_outside = sqrt(x_sing.^2 + y_sing.^2) >= a;
    x_sing = x_sing(sing_outside);
    y_sing = y_sing(sing_outside);
    
    %% Compute Stagnation Points
    % Stagnation points occur where dW/dz = 0
    switch lower(flow_type)
        case 'cylinder'
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
            
        case 'doublet'
            % dW/dz = v_0(1 - a^2/z^2) = 0
            % Solving: z^2 = a^2 => z = ±a
            x_stag = [a; -a];
            y_stag = [0; 0];
            
        case 'vortex'
            % dW/dz = v_0(1 - a^2/z^2) + i*mu/z = 0
            % Multiply by z^2: v_0*z^2 - v_0*a^2 + i*mu*z = 0
            % Quadratic: v_0*z^2 + i*mu*z - v_0*a^2 = 0
            % z = [-i*mu ± sqrt(-mu^2 + 4*v_0^2*a^2)] / (2*v_0)
            discriminant = -mu^2 + 4*v_0^2*a^2;
            z_stag = [(-1i*mu + sqrt(discriminant))/(2*v_0); ...
                      (-1i*mu - sqrt(discriminant))/(2*v_0)];
            x_stag = real(z_stag);
            y_stag = imag(z_stag);
            % Filter stagnation points outside the cylinder
            stag_outside = sqrt(x_stag.^2 + y_stag.^2) >= a;
            x_stag = x_stag(stag_outside);
            y_stag = y_stag(stag_outside);
            
        case 'source'
            % dW/dz = v_0(1 - a^2/z^2) + mu/z = 0
            % Multiply by z^2: v_0*z^2 - v_0*a^2 + mu*z = 0
            % Quadratic: v_0*z^2 + mu*z - v_0*a^2 = 0
            % z = [-mu ± sqrt(mu^2 + 4*v_0^2*a^2)] / (2*v_0)
            discriminant = mu^2 + 4*v_0^2*a^2;
            z_stag = [(-mu + sqrt(discriminant))/(2*v_0); ...
                      (-mu - sqrt(discriminant))/(2*v_0)];
            x_stag = real(z_stag);
            y_stag = imag(z_stag);
            % Filter stagnation points outside the cylinder
            stag_outside = sqrt(x_stag.^2 + y_stag.^2) >= a;
            x_stag = x_stag(stag_outside);
            y_stag = y_stag(stag_outside);
            
        case 'cylinder_log'
            % dW/dz = v_0(1 - a^2/z^2) - i*mu/(2*pi*z) = 0
            % Multiply by z^2: v_0*z^2 - v_0*a^2 - i*mu*z/(2*pi) = 0
            % Quadratic: v_0*z^2 - i*mu*z/(2*pi) - v_0*a^2 = 0
            % z = [i*mu/(2*pi) ± sqrt(-mu^2/(4*pi^2) + 4*v_0^2*a^2)] / (2*v_0)
            discriminant = -mu^2/(4*pi^2) + 4*v_0^2*a^2;
            z_stag = [(1i*mu/(2*pi) + sqrt(discriminant))/(2*v_0); ...
                      (1i*mu/(2*pi) - sqrt(discriminant))/(2*v_0)];
            x_stag = real(z_stag);
            y_stag = imag(z_stag);
            % Filter stagnation points outside the cylinder
            stag_outside = sqrt(x_stag.^2 + y_stag.^2) >= a;
            x_stag = x_stag(stag_outside);
            y_stag = y_stag(stag_outside);
    end
    
    %% Figure 1: Streamlines and Equipotential Lines
    figure(fig_start)
    set(gcf, 'Position', [100, 100, 800, 700]);
    hold on;
    h_stream = contour(X, Y, psi, 30, 'm');  % Streamlines (magenta)
    h_equip = contour(X, Y, phi, 30, 'b--');  % Equipotential lines (blue dashed)
    
    % Draw the cylinder (for all flow types)
    theta_cyl = linspace(0, 2*pi, 100);
    x_cyl = a * cos(theta_cyl);
    y_cyl = a * sin(theta_cyl);
    fill(x_cyl, y_cyl, [0.8, 0.8, 0.8]);  % Gray filled cylinder
    h_cyl = plot(x_cyl, y_cyl, 'k-', 'LineWidth', 2);  % Cylinder boundary
    
    % Plot singularities
    if ~isempty(x_sing)
        h_sing = plot(x_sing, y_sing, 'x', 'MarkerSize', 14, 'Color', [0, 0.4, 0.8], 'LineWidth', 3);
    end
    
    % Plot stagnation points
    if ~isempty(x_stag)
        h_stag = plot(x_stag, y_stag, 'o', 'MarkerSize', 12, 'MarkerFaceColor', [0.5, 0, 0.13], 'MarkerEdgeColor', [0.5, 0, 0.13], 'LineWidth', 2);
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
    
    % Set title based on flow type
    switch lower(flow_type)
        case 'cylinder'
            if mu == 0
                title(['Flow Around Cylinder: W(z) = v_0(z + a^2/z), a = ' num2str(a) ', v_0 = ' num2str(v_0)]);
            else
                title(['Flow with Circulation: W(z) = v_0(z + a^2/z) - i\mu/z, \mu = ' num2str(mu)]);
            end
        case 'doublet'
            title(['Doublet Around Cylinder: W(z) = v_0(z + a^2/z), v_0 = ' num2str(v_0)]);
        case 'vortex'
            title(['Vortex Around Cylinder: W(z) = v_0(z + a^2/z) + i\mu log(z/a), \mu = ' num2str(mu)]);
        case 'source'
            if mu > 0
                title(['Source Around Cylinder: W(z) = v_0(z + a^2/z) + Q log(z/a), Q = ' num2str(mu)]);
            else
                title(['Sink Around Cylinder: W(z) = v_0(z + a^2/z) + Q log(z/a), Q = ' num2str(mu)]);
            end
        case 'cylinder_log'
            title(['Flow with Circulation (Log): W(z) = v_0(z + a^2/z) - i\mu log(z)/(2\pi), \mu = ' num2str(mu)]);
    end
    
    % Build legend based on what's plotted using explicit handles
    legend_handles = [h_stream(1), h_equip(1)];
    legend_labels = {'Streamlines (\psi)', 'Equipotential lines (\phi)'};
    
    legend_handles(end+1) = h_cyl;
    legend_labels{end+1} = 'Cylinder';
    
    if ~isempty(x_sing) && exist('h_sing', 'var')
        legend_handles(end+1) = h_sing;
        legend_labels{end+1} = 'Singularities';
    end
    if ~isempty(x_stag) && exist('h_stag', 'var')
        legend_handles(end+1) = h_stag;
        legend_labels{end+1} = 'Stagnation points';
    end
    lgd = legend(legend_handles, legend_labels, 'Location', 'southwest', 'FontSize', 7);
    lgd.Position(1) = 0.3;  % Move legend slightly right from left edge
    lgd.Position(2) = 0.15;  % Move legend slightly up from bottom edge
    hold off;
    
    %% Calculate velocity field
    % Velocity: u - iv = dW/dz
    r4 = r2.^2;
    
    switch lower(flow_type)
        case 'cylinder'
            % dW/dz = v_0(1 - a^2/z^2) + i*mu/z^2
            % u = v_0(1 - a^2*(x^2 - y^2)/r^4) - 2*mu*x*y/r^4
            % v = v_0(2*a^2*x*y/r^4) + mu*(x^2 - y^2)/r^4
            u = v_0 * (1 - a^2 * (X.^2 - Y.^2) ./ r4) - 2*mu * X .* Y ./ r4;
            v = v_0 * (2 * a^2 * X .* Y ./ r4) + mu * (X.^2 - Y.^2) ./ r4;
            u(inside_cylinder) = NaN;
            v(inside_cylinder) = NaN;
            
        case 'doublet'
            % Doublet Around Cylinder: dW/dz = v_0(1 - a^2/z^2)
            % u = v_0(1 - a^2*(x^2 - y^2)/r^4)
            % v = v_0(2*a^2*x*y/r^4)
            u = v_0 * (1 - a^2 * (X.^2 - Y.^2) ./ r4);
            v = v_0 * (2 * a^2 * X .* Y ./ r4);
            u(inside_cylinder) = NaN;
            v(inside_cylinder) = NaN;
            
        case 'vortex'
            % Vortex Around Cylinder: dW/dz = v_0(1 - a^2/z^2) + i*mu/z
            % u = v_0(1 - a^2*(x^2 - y^2)/r^4) - mu*y/r^2
            % v = v_0(2*a^2*x*y/r^4) + mu*x/r^2
            u = v_0 * (1 - a^2 * (X.^2 - Y.^2) ./ r4) - mu * Y ./ r2;
            v = v_0 * (2 * a^2 * X .* Y ./ r4) + mu * X ./ r2;
            u(inside_cylinder) = NaN;
            v(inside_cylinder) = NaN;
            
        case 'source'
            % Source Around Cylinder: dW/dz = v_0(1 - a^2/z^2) + mu/z
            % u = v_0(1 - a^2*(x^2 - y^2)/r^4) + mu*x/r^2
            % v = v_0(2*a^2*x*y/r^4) + mu*y/r^2
            u = v_0 * (1 - a^2 * (X.^2 - Y.^2) ./ r4) + mu * X ./ r2;
            v = v_0 * (2 * a^2 * X .* Y ./ r4) + mu * Y ./ r2;
            u(inside_cylinder) = NaN;
            v(inside_cylinder) = NaN;
            
        case 'cylinder_log'
            % Cylinder with Log Circulation: dW/dz = v_0(1 - a^2/z^2) - i*mu/(2*pi*z)
            % u = v_0(1 - a^2*(x^2 - y^2)/r^4) - mu*y/(2*pi*r^2)
            % v = v_0(2*a^2*x*y/r^4) - mu*x/(2*pi*r^2)
            u = v_0 * (1 - a^2 * (X.^2 - Y.^2) ./ r4) - mu * Y ./ (2*pi*r2);
            v = v_0 * (2 * a^2 * X .* Y ./ r4) - mu * X ./ (2*pi*r2);
            u(inside_cylinder) = NaN;
            v(inside_cylinder) = NaN;
    end
    
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
    
    % Draw cylinder (for all flow types)
    theta_cyl = linspace(0, 2*pi, 100);
    x_cyl = a * cos(theta_cyl);
    y_cyl = a * sin(theta_cyl);
    fill(x_cyl, y_cyl, [0.5, 0.5, 0.5]);
    h_cyl = plot(x_cyl, y_cyl, 'k-', 'LineWidth', 2);
    
    % Plot singularities on velocity magnitude plot
    if ~isempty(x_sing)
        h_sing = plot(x_sing, y_sing, 'x', 'MarkerSize', 14, 'Color', [0, 0.4, 0.8], 'LineWidth', 3);
    end
    
    % Plot stagnation points on velocity magnitude plot
    if ~isempty(x_stag)
        h_stag = plot(x_stag, y_stag, 'o', 'MarkerSize', 12, 'MarkerFaceColor', [0.5, 0, 0.13], 'MarkerEdgeColor', [0.5, 0, 0.13], 'LineWidth', 2);
    end
    
    % Build legend dynamically
    legend_handles = [h_cyl];
    legend_labels = {'Cylinder'};
    if ~isempty(x_sing) && exist('h_sing', 'var')
        legend_handles(end+1) = h_sing;
        legend_labels{end+1} = 'Singularities';
    end
    if ~isempty(x_stag) && exist('h_stag', 'var')
        legend_handles(end+1) = h_stag;
        legend_labels{end+1} = 'Stagnation Points';
    end
    if ~isempty(legend_handles)
        lgd = legend(legend_handles, legend_labels, 'Location', 'southwest', 'FontSize', 7);
        lgd.Position(1) = 0.30;  % Move legend slightly right from left edge
        lgd.Position(2) = 0.15;  % Move legend slightly up from bottom edge
    end
    
    axis equal;
    xlim([-3, 3]);
    ylim([-3, 3]);
    xlabel('Real(z)');
    ylabel('Imag(z)');
    
    % Set title based on flow type
    switch lower(flow_type)
        case 'cylinder'
            if mu == 0
                title('Velocity Magnitude |V| - Flow Around Cylinder');
            else
                title('Velocity Magnitude |V| - Flow with Circulation');
            end
        case 'doublet'
            title('Velocity Magnitude |V| - Doublet Around Cylinder');
        case 'vortex'
            title('Velocity Magnitude |V| - Vortex Around Cylinder');
        case 'source'
            if mu > 0
                title('Velocity Magnitude |V| - Source Around Cylinder');
            else
                title('Velocity Magnitude |V| - Sink Around Cylinder');
            end
        case 'cylinder_log'
            title('Velocity Magnitude |V| - Flow with Circulation (Log)');
    end
    hold off;
    
    %% Print Analysis
    switch lower(flow_type)
        case 'cylinder'
            fprintf('Flow type: Cylinder flow\n');
            fprintf('Cylinder radius: a = %.2f\n', a);
            fprintf('Free stream velocity: v_0 = %.2f\n', v_0);
            fprintf('Circulation parameter: mu = %.2f\n', mu);
        case 'doublet'
            fprintf('Flow type: Doublet around cylinder\n');
            fprintf('Cylinder radius: a = %.2f\n', a);
            fprintf('Free stream velocity: v_0 = %.2f\n', v_0);
        case 'cylinder_log'
            fprintf('Flow type: Cylinder flow with log circulation\n');
            fprintf('Cylinder radius: a = %.2f\n', a);
            fprintf('Free stream velocity: v_0 = %.2f\n', v_0);
            fprintf('Circulation: Gamma = %.2f\n', mu);
        case 'vortex'
            fprintf('Flow type: Vortex around cylinder\n');
            fprintf('Cylinder radius: a = %.2f\n', a);
            fprintf('Free stream velocity: v_0 = %.2f\n', v_0);
            fprintf('Circulation: Gamma = %.2f\n', mu);
        case 'source'
            if mu > 0
                fprintf('Flow type: Source around cylinder\n');
            else
                fprintf('Flow type: Sink around cylinder\n');
            end
            fprintf('Cylinder radius: a = %.2f\n', a);
            fprintf('Free stream velocity: v_0 = %.2f\n', v_0);
            fprintf('Strength: Q = %.2f\n', mu);
    end
    
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
    mu_values = linspace(0, 8, 200);
    
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
    mu_markers = [0, 2, 4, 6, 8];
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

function plot_stagnation_trajectory_vortex(a, v_0, fig_num)
    % Plot trajectory of stagnation points for vortex flow as mu varies
    % For vortex flow: dW/dz = v_0(1 - a^2/z^2) + i*mu/z = 0
    % Stagnation points: z = [-i*mu ± sqrt(-mu^2 + 4*v_0^2*a^2)] / (2*v_0)
    % Inputs:
    %   a - cylinder radius
    %   v_0 - free stream velocity
    %   fig_num - figure number
    
    % Range of mu values to explore
    mu_values = linspace(0, 8, 200);
    
    % Storage for stagnation point trajectories
    % Two branches: positive and negative sqrt
    stag_pos_x = zeros(size(mu_values));
    stag_pos_y = zeros(size(mu_values));
    stag_neg_x = zeros(size(mu_values));
    stag_neg_y = zeros(size(mu_values));
    
    % Compute stagnation points for each mu
    for i = 1:length(mu_values)
        mu = mu_values(i);
        % Stagnation points: v_0*z^2 + i*mu*z - v_0*a^2 = 0
        % z = [-i*mu ± sqrt(-mu^2 + 4*v_0^2*a^2)] / (2*v_0)
        discriminant = -mu^2 + 4*v_0^2*a^2;
        z_pos = (-1i*mu + sqrt(discriminant))/(2*v_0);
        z_neg = (-1i*mu - sqrt(discriminant))/(2*v_0);
        
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
    mu_markers = [0, 1, 2, 3, 4, 5, 6, 7, 8];
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
    title(sprintf('Vortex Flow: Stagnation Point Trajectories as \\mu varies (0 to %.1f)', max(mu_values)));
    legend([h1, h2], {'Branch 1: +sqrt', 'Branch 2: -sqrt'}, 'Location', 'southwest', 'FontSize', 8);
    grid on;
    hold off;
    
    fprintf('Vortex flow stagnation point trajectory computed for mu in [0, %.2f]\n', max(mu_values));
    fprintf('At mu = 0: stagnation points at z = +/-%.2f (on real axis)\n', a);
    fprintf('As mu increases: points move in complex plane\n');
    fprintf('Critical mu = %.2f: transition point where discriminant = 0\n', 2*v_0*a);
end