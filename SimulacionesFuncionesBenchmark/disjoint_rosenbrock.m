clc; clear;

%% Parámetros
dim = 2;
bounds = [-6, 6];         % espacio total
numGenerations = 30;
changeInterval = 10;
penaltyValue = 100;       % valor fuera de los nichos
gridStep = 0.2;

% Subregiones disjuntas (ej: 4 regiones)
regions = [
    -6, -3, -6, -3;  % [x1min x1max x2min x2max]
    3, 6, -6, -3;
    -6, -3, 3, 6;
    3, 6, 3, 6
];
numRegions = size(regions, 1);

% Centros dinámicos para cada región
regionCenters = zeros(numRegions, dim);
for i = 1:numRegions
    regionCenters(i,:) = [(regions(i,1)+regions(i,2))/2, (regions(i,3)+regions(i,4))/2];
end

% Grid para visualizar
[X, Y] = meshgrid(bounds(1):gridStep:bounds(2));
Z = zeros(size(X));

%% Loop
for t = 1:numGenerations
    % Actualizar óptimos dentro de cada subregión
    if mod(t, changeInterval) == 0
        for i = 1:numRegions
            % nuevo centro aleatorio dentro de la subregión
            x1 = rand * (regions(i,2) - regions(i,1)) + regions(i,1);
            x2 = rand * (regions(i,4) - regions(i,3)) + regions(i,3);
            regionCenters(i,:) = [x1, x2];
        end
        fprintf(">>> Cambio de óptimos regionales en generación %d <<<\n", t);
    end

    % Evaluar en el grid
    for i = 1:size(X,1)
        for j = 1:size(X,2)
            pt = [X(i,j), Y(i,j)];
            inRegion = false;
            minVal = Inf;
            for r = 1:numRegions
                if pt(1) >= regions(r,1) && pt(1) <= regions(r,2) && ...
                   pt(2) >= regions(r,3) && pt(2) <= regions(r,4)
                    inRegion = true;
                    shifted = pt - regionCenters(r,:);
                    val = rastrigin(shifted);
                    if val < minVal
                        minVal = val;
                    end
                end
            end
            Z(i,j) = inRegion * minVal + (~inRegion) * penaltyValue;
        end
    end

    % Evaluación de punto de prueba
    x_test = [0 0];
    testVal = penaltyValue;
    for r = 1:numRegions
        if x_test(1) >= regions(r,1) && x_test(1) <= regions(r,2) && ...
           x_test(2) >= regions(r,3) && x_test(2) <= regions(r,4)
            shifted = x_test - regionCenters(r,:);
            testVal = rastrigin(shifted);
        end
    end
    fprintf("Gen %d | f([0 0]) = %.4f\n", t, testVal);

    % Visualización
    surf(X, Y, Z);
    title(sprintf('Disjoint Landscape Benchmark - Gen %d', t));
    xlabel('x_1'); ylabel('x_2'); zlabel('f(x)');
    axis([bounds(1) bounds(2) bounds(1) bounds(2) 0 penaltyValue]);
    drawnow;
end

%% Rastrigin fijo
function f = rastrigin(x)
    A = 10;
    f = A * numel(x) + sum(x.^2 - A * cos(2 * pi * x));
end