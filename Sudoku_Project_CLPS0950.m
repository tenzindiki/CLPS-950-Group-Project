function soduko_grid = Sudoku_Project_CLPS0950()
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
    soduko_grid = generate_soduko();

    % Create blanks in grid based on user's selected difficulty level
    soduko_grid = create_blanks(soduko_grid, difficulty_level); 

    % Display the sudoku grid with grid lines
    display_sudoku(soduko_grid); % Displays sudoku grid
end

function soduko_grid = generate_soduko()
    soduko_grid = zeros(9); % Initialization of grid
    base_grid = reshape(randperm(9), [3,3]); % Generate random 3x3 block

    % Create first three rows using row shifting
    soduko_grid(1:3, 1:3) = base_grid; 
    soduko_grid(1:3, 4:6) = circshift(base_grid, -1, 1);
    soduko_grid(1:3, 7:9) = circshift(base_grid, -2, 1);

    % Create next 6 rows using column shifting
    soduko_grid(4:6, :) = circshift(soduko_grid(1:3, :), -1, 2);
    soduko_grid(7:9, :) = circshift(soduko_grid(1:3, :), -2, 2);
end 

function soduko_grid = create_blanks(soduko_grid, count)
    % Get random indices for blanks
    indices = randperm(81, count); 

    for ii = 1:length(indices)
        row = ceil(indices(ii) / 9);
        col = mod(indices(ii) - 1, 9) + 1;
        soduko_grid(row, col) = 0; % Set blank cells
    end
end

function display_sudoku(soduko_grid)
    for i = 1:9
        if mod(i-1,3) == 0 && i > 1
            fprintf('---------------------\n');
        end
        for j = 1:9
            if mod(j-1,3) == 0 && j > 1
                fprintf('| ');
            end
            if soduko_grid(i, j) == 0
                fprintf('. '); % Display blanks
            else
                fprintf('%d ', soduko_grid(i, j));
            end
        end
        fprintf('\n');
    end
end