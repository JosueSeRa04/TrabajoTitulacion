clc; clear;

%% Parámetros del Benchmark
numPeaks = 5;
dim = 2;
bounds = [-50, 50];
severity = 1.0;
changeFrequency = 10;
numGenerations = 50;

%% Inicialización de los picos
h = 30 + 40 * rand(numPeaks, 1);  % Altura: [30, 70]
w = 1 + 4 * rand(numPeaks, 1);    % Ancho: [1, 5]
c = bounds(1) + (bounds(2)-bounds(1)) * rand(numPeaks, dim); % Centros aleatorios

%% Evaluación + visualización + actualización dinámica
[X, Y] = meshgrid(bounds(1):2:bounds(2));
Z = zeros(size(X));

for t = 1:numGenerations
    % Actualizar los picos si corresponde
    if mod(t, changeFrequency) == 0
        [h, w, c] = update_peaks(h, w, c, bounds, severity);
        fprintf(">>> Cambio de picos en generación %d <<<\n", t);
    end

    % Evaluar la función en todos los puntos del grid
    for i = 1:size(X,1)
        for j = 1:size(X,2)
            point = [X(i,j), Y(i,j)];
            Z(i,j) = mpb_eval(point, h, w, c);
        end
    end

    % Evaluar en el origen y mostrar en consola
    x_test = [0 0];
    val = mpb_eval(x_test, h, w, c);
    fprintf("Gen %d | f([0 0]) = %.4f\n", t, val);

    % Visualizar superficie
    surf(X, Y, Z);
    title(sprintf('Moving Peaks Benchmark - Generación %d', t));
    xlabel('x_1'); ylabel('x_2'); zlabel('f(x)');
    axis([bounds(1) bounds(2) bounds(1) bounds(2) min(Z(:)) max(Z(:))]);
    drawnow;
end

%% Función de evaluación del MPB
function val = mpb_eval(x, h, w, c)
    numPeaks = size(h,1);
    values = zeros(numPeaks,1);
    for i = 1:numPeaks
        dist = norm(x - c(i,:));
        values(i) = h(i) * exp(- (dist^2) / (2 * w(i)^2));
    end
    val = max(values);
end

%% Función de actualización de los picos
function [h, w, c] = update_peaks(h, w, c, bounds, severity)
    % Cambio aleatorio pequeño en las posiciones
    delta = severity * (2 * rand(size(c)) - 1); % entre [-severity, +severity]
    c = c + delta;

    % Limitar al dominio
    c = max(min(c, bounds(2)), bounds(1));

    % (Opcional) También podrías cambiar altura y ancho:
    h = h + 2 * (rand(size(h)) - 0.5); % pequeños cambios en altura
    w = w + 0.1 * (rand(size(w)) - 0.5); % pequeños cambios en ancho
    w = max(w, 0.5); % evitar que w sea muy pequeño
end