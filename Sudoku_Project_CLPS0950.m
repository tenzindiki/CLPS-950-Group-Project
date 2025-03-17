function sudoku_grid = Sudoku_Project_CLPS0950()
sudoku_grid = zeros(9); % initialization of grid
sudoku_grid = fillSudoku(sudoku_grid);
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
    nums = randperm(9); % randomizes numbers 1-9
    M(1,4:6) = N(2,:) = Q(1:3);

