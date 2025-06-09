clc; clear;

%% Parámetros
numCities = 20;
bounds = [0, 100];
numGenerations = 40;
changeFrequency = 10;
numCitiesToMove = 5; % severidad del cambio

% Inicializar ciudades aleatoriamente
cities = bounds(1) + (bounds(2)-bounds(1)) * rand(numCities, 2);

% Ruta inicial aleatoria
route = randperm(numCities);

%% Loop generacional
for t = 1:numGenerations
    % Cambio dinámico: mover algunas ciudades
    if mod(t, changeFrequency) == 0
        idx = randperm(numCities, numCitiesToMove);
        cities(idx, :) = cities(idx, :) + 10 * (rand(numCitiesToMove, 2) - 0.5);
        cities = max(min(cities, bounds(2)), bounds(1)); % mantener dentro de límites
        fprintf(">>> Cambio en topología en generación %d <<<\n", t);
    end

    % Calcular distancia total
    totalDist = tsp_length(cities, route);
    fprintf("Gen %d | Longitud de ruta: %.2f\n", t, totalDist);

    % Visualización
    clf;
    plot([cities(route,1); cities(route(1),1)], ...
         [cities(route,2); cities(route(1),2)], '-o', 'LineWidth', 2);
    title(sprintf('Dynamic TSP (Gen %d)', t));
    xlim([bounds(1) bounds(2)]); ylim([bounds(1) bounds(2)]);
    xlabel('x'); ylabel('y');
    drawnow;
end

%% Función para calcular la longitud de la ruta
function dist = tsp_length(cities, route)
    dist = 0;
    for i = 1:length(route)
        from = cities(route(i), :);
        to = cities(route(mod(i, length(route)) + 1), :);
        dist = dist + norm(from - to);
    end
end