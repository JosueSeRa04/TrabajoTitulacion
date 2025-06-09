clc; clear;

%% Parámetros
dim = 2;
bounds = [-5.12, 5.12]; % Rango típico para Rastrigin
numGenerations = 50;
changeFrequency = 10;
rotationAngleStep = pi / 10;
translationStep = 0.5;

%% Inicialización
center = zeros(1, dim); % Traslación del óptimo
angle = 0;

% Grid para visualización
[X, Y] = meshgrid(bounds(1):0.2:bounds(2));
Z = zeros(size(X));

%% Loop temporal
for t = 1:numGenerations
    % Cambiar entorno
    if mod(t, changeFrequency) == 0
        angle = angle + rotationAngleStep;
        center = center + translationStep * (2*rand(1,dim)-1);
        fprintf(">>> Cambio en el entorno en generación %d <<<\n", t);
    end

    % Rotación 2D
    R = [cos(angle) -sin(angle); sin(angle) cos(angle)];

    % Evaluar
    for i = 1:size(X,1)
        for j = 1:size(X,2)
            x = [X(i,j), Y(i,j)];
            xTrans = R * (x(:) - center(:));
            Z(i,j) = rastrigin(xTrans');
        end
    end

    % Punto de prueba
    x_test = [0 0];
    xTrans = R * (x_test(:) - center(:));
    val = rastrigin(xTrans');
    fprintf("Gen %d | f([0 0]) = %.4f\n", t, val);

    % Visualización
    surf(X, Y, Z);
    title(sprintf('GDBG con Rastrigin - Generación %d', t));
    xlabel('x_1'); ylabel('x_2'); zlabel('f(x)');
    axis([bounds(1) bounds(2) bounds(1) bounds(2) 0 50]);
    drawnow;
end

%% Función Rastrigin
function f = rastrigin(x)
    A = 10;
    f = A * numel(x) + sum(x.^2 - A * cos(2 * pi * x));
end