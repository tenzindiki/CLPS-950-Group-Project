

clc; clear; close all;

% Ask user for grid size
n = input('Enter grid size (4 or 9): ');
if n ~= 4 && n ~= 9
    error('Invalid input. Please enter 4 or 9.');
end

sudokuGrid = generateSudoku(n); % Generate a filled Sudoku grid

% Ask user for difficulty level
difficultyLevels = [2, 4, 6, 8, 10]; % Number of blanks for 4x4, scale for 9x9
difficulty = input('Select difficulty (1-5): ');
if difficulty < 1 || difficulty > 5
    error('Invalid difficulty. Choose between 1 and 5.');
end

numBlanks = round(difficultyLevels(difficulty) * (n/4)^2); 

sudokuGrid = createBlanks(sudokuGrid, numBlanks);

% Display the grid
figure;
imagesc(sudokuGrid);
colormap([1 1 1]); % Set colormap to white
axis equal;
ax = gca;
ax.XColor = 'k';
ax.YColor = 'k';
ax.XTick = 0.5:1:n+0.5;
ax.YTick = 0.5:1:n+0.5;
ax.XTickLabel = [];
ax.YTickLabel = [];
grid on;

% Determine bold grid lines based on size
subGridSize = 2; % Default for 4x4
if n == 9
    subGridSize = 3;
end

% Draw bold lines for sub-grids
hold on;
for i = 0:(n/subGridSize)
    x = [0.5, n+0.5];
    y = [i*subGridSize+0.5, i*subGridSize+0.5];
    plot(x, y, 'k', 'LineWidth', 2);
    plot(y, x, 'k', 'LineWidth', 2);
end
hold off;

title(['Sudoku Grid (', num2str(n), 'x', num2str(n), ')']);

% Function to generate a valid filled Sudoku grid
function grid = generateSudoku(n)
    grid = zeros(n);
    nums = randperm(n);
    for i = 1:n
        grid(i, :) = circshift(nums, i-1);
    end
end

% Function to create blanks in the Sudoku grid
function grid = createBlanks(grid, count)
    count = min(count, numel(grid)); % Ensure count does not exceed grid size
    indices = randperm(numel(grid), count);
    grid(indices) = 0;
end
