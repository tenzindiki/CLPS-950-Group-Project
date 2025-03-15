function sudoku_grid = Sudoku_Project_CLPS0950()
sudoku_grid = zeros(9); % initialization of grid
num_of_blanks = [20,30,40,50,60]; % possible number of blanks
fprintf('Welcome to our Sudoku!\n'); % welcome message
sudoku_difficulty = input('Which level of difficulty would you like to select? Please enter a number from 1-5. (1: a two year old could do this, 2: easy, 3: medium, 4: hard, 5: DANGER!!) \n'); % prompt for user
    if sudoku_difficulty >= 1 && sudoku_difficulty <= 5 % restricts range of valid choices
        difficulty_level = num_of_blanks(sudoku_difficulty); % assigns number of blanks in sudoku grid to each difficulty level
    else
        fprintf('Please enter a number from 1-5.\n')
    end
    sudoku_grid = create_blanks(sudoku_grid, difficulty_level); % creates blanks in grid based on user's selected difficulty level
disp(sudoku_grid); % displays sudoku grid
end
function grid = fillSudoku(grid)
    [row, col] = find(grid == 0, 1); % finds the first empty cell in grid (0)
    nums = randperm(9); % randomizes numbers 1-9
    for num = nums % places numbers in grid
        if isValid(grid, row, col, num)
            grid(row, col) = num;
            if all(grid(:) > 0) || ~isempty(fillSudoku(grid))
                return;
            end
            grid(row, col) = 0;
        end
    end
    grid = []; % backtracks if no valid number is found
end

function valid = isValid(grid, row, col, num) % validates numbers in grid
    valid = ~ismember(num, grid(row, :)) && ...
            ~ismember(num, grid(:, col)) && ...
            ~ismember(num, grid(3 * floor((row - 1) / 3) + (1:3), 3 * floor((col - 1) / 3) + (1:3)));
end

function grid = create_blanks(grid, count) 
    indices = randperm(81, count); % creates blanks at random intervals in grid
    for ii = 1:length(indices)
        row = ceil(indices(ii) / 9);
        col = mod(indices(ii) - 1, 9) + 1;
        grid(row, col) = 0; % populates field with a '0' if blank
    end
end
