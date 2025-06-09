clc; clear;

%% Parámetros generales
dim = 2;
bounds = [-5, 5];
numGenerations = 40;
numPeaks = 4;

%% Logística (DF1)
k = 0.4;         % qué tan rápido ocurre el cambio
t0 = 20;         % centro del cambio

%% Inicialización de parámetros base
rng(1); % reproducibilidad
h0 = 30 + 20 * rand(numPeaks,1);
ch = 20 * (2 * rand(numPeaks,1) - 1); % ∆h
w0 = 1 + 1.5 * rand(numPeaks,1);
cw = 0.5 * (2 * rand(numPeaks,1) - 1); % ∆w
c0 = bounds(1) + (bounds(2) - bounds(1)) * rand(numPeaks, dim);
cc = 2 * (rand(numPeaks,dim) - 0.5); % ∆c

[X, Y] = meshgrid(bounds(1):0.2:bounds(2));
Z = zeros(size(X));

%% Loop generacional
for t = 1:numGenerations
    L = 1 ./ (1 + exp(-k*(t - t0))); % función logística

    h = h0 + ch * L;
    w = w0 + cw * L;
    c = c0 + cc * L;

    % Evaluar en la grilla
    for i = 1:size(X,1)
        for j = 1:size(X,2)
            x = [X(i,j), Y(i,j)];
            Z(i,j) = gaussian_mixture(x, h, w, c);
        end
    end

    % Evaluar punto de prueba
    x_test = [0 0];
    val = gaussian_mixture(x_test, h, w, c);
    fprintf("Gen %d | f([0 0]) = %.4f\n", t, val);

    % Visualizar
    surf(X, Y, Z);
    title(sprintf('DF1 - Gen %d', t));
    xlabel('x_1'); ylabel('x_2'); zlabel('f(x)');
    axis([bounds(1) bounds(2) bounds(1) bounds(2) 0 max(Z(:))]);
    drawnow;
end

%% Función de mezcla de gaussianas
function val = gaussian_mixture(x, h, w, c)
    m = size(c,1);
    vals = zeros(m,1);
    for i = 1:m
        dist = norm(x - c(i,:));
        vals(i) = h(i) * exp(- (dist^2) / (2 * w(i)^2));
    end
    val = max(vals);
end