clc; clear;

%% Parámetros
dim = 2;
bounds = [-5.12, 5.12];
numGenerations = 40;
changeInterval = 10; % Cada cuántas generaciones cambia el paisaje

% Definir 3 configuraciones distintas de Rastrigin
configs(1).A = 10;  configs(1).center = [0, 0];
configs(2).A = 15;  configs(2).center = [1.5, -1.5];
configs(3).A = 5;   configs(3).center = [-2, 2];

% Grid
[X, Y] = meshgrid(bounds(1):0.2:bounds(2));
Z = zeros(size(X));

%% Loop
for t = 1:numGenerations
    % Cambiar configuración abruptamente
    configIndex = ceil(t / changeInterval);
    if configIndex > length(configs)
        configIndex = length(configs);
    end
    config = configs(configIndex);
    A = config.A;
    center = config.center;

    fprintf("Generación %d | Configuración %d (A = %.1f, centro = [%.1f, %.1f])\n", ...
        t, configIndex, A, center(1), center(2));

    % Evaluar en grid
    for i = 1:size(X,1)
        for j = 1:size(X,2)
            x = [X(i,j), Y(i,j)] - center;
            Z(i,j) = rastrigin(x, A);
        end
    end

    % Evaluar en punto de prueba
    x_test = [0 0] - center;
    val = rastrigin(x_test, A);
    fprintf("f([0 0] ajustado) = %.4f\n", val);

    % Visualizar
    surf(X, Y, Z);
    title(sprintf('Switching Benchmark - Gen %d', t));
    xlabel('x_1'); ylabel('x_2'); zlabel('f(x)');
    axis([bounds(1) bounds(2) bounds(1) bounds(2) 0 100]);
    drawnow;
end

%% Función Rastrigin con amplitud variable
function f = rastrigin(x, A)
    f = A * numel(x) + sum(x.^2 - A * cos(2 * pi * x));
end