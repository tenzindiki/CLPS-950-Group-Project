function sudoku_grid = Sudoku_Project_CLPS0950()
sudoku_grid = zeros(9); % initialization of grid
sudoku_grid = fillSudoku(sudoku_grid);
end

    fprintf('Welcome to our Sudoku!\n'); % welcome message
    num_of_blanks = [20,30,40,50,60]; % possible number of blanks


    % Prompt user for difficulty level
    sudoku_difficulty = input('Which level of difficulty would you like to select? Please enter a number from 1-5. (1: a two year old could do this, 2: easy, 3: medium, 4: hard, 5: DANGER!!) \n'); 

    if sudoku_difficulty >= 1 && sudoku_difficulty <= 5 % Restrict range of valid choices
        difficulty_level = num_of_blanks(sudoku_difficulty); % Assign blanks to difficulty
    else
        fprintf('Invalid selection. Defaulting to medium difficulty.\n')
        difficulty_level = num_of_blanks(3);
    end

    % Generate sudoku grid
    sudoku_grid = generate_sudoku();

    % Create blanks in grid based on user's selected difficulty level
    sudoku_grid = create_blanks(sudoku_grid, difficulty_level); 

    % Display the sudoku grid with grid lines
    display_sudoku(sudoku_grid); % Displays sudoku grid

function grid = fillSudoku(grid)
    nums = randperm(9); % randomizes numbers 1-9
    M(1,4:6) = N(2,:) = Q(1:3);
end

function sudoku_grid = generate_sudoku()
    sudoku_grid = zeros(9); % Initialization of grid
    base_grid = reshape(randperm(9), [3,3]); % Generate random 3x3 block

    % Create first three rows using row shifting
    sudoku_grid(1:3, 1:3) = base_grid; 
    sudoku_grid(1:3, 4:6) = circshift(base_grid, -1, 1);
    sudoku_grid(1:3, 7:9) = circshift(base_grid, -2, 1);

    % Create next 6 rows using column shifting
    sudoku_grid(4:6, :) = circshift(sudoku_grid(1:3, :), -1, 2);
    sudoku_grid(7:9, :) = circshift(sudoku_grid(1:3, :), -2, 2);
end 

function sudoku_grid = create_blanks(sudoku_grid, count)
    % Get random indices for blanks
    indices = randperm(81, count); 

    for ii = 1:length(indices)
        row = ceil(indices(ii) / 9);
        col = mod(indices(ii) - 1, 9) + 1;
        sudoku_grid(row, col) = 0; % Set blank cells
    end
end

function display_sudoku(sudoku_grid)
    for i = 1:9
        if mod(i-1,3) == 0 && i > 1
            fprintf('---------------------\n');
        end
        for j = 1:9
            if mod(j-1,3) == 0 && j > 1
                fprintf('| ');
            end
            if sudoku_grid(i, j) == 0
                fprintf('. '); % Display blanks
            else
                fprintf('%d ', sudoku_grid(i, j));
            end
        end
        fprintf('\n');
    end
end
