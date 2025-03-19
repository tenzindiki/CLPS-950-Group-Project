
    fprintf('Welcome to our Sudoku!\n'); % welcome message
    fprintf('If you would like a hint, feel free to type the word "hint" at any point during the game. \n'); fprintf('If you would like the game to be solved for you, just type "solve it for me"! \n');
    fprintf('If you would like to quit the game, please type "exit." \n');

    sudoku_grid = Sudoku_Proj_CLPS0950();
    display_sudoku(sudoku_grid); % displays sudoku grid

    while true % infinite loop until user types "exit"
        user_input = input('Type "hint" to reveal one number in the grid or "solve it for me" to reveal the completed grid. Alternatively, type "exit" to quit the game: ', 's'); % prompts user with the option to get a hint or quit the game (if they so choose)
        if strcmp(user_input, 'exit')
            break;
        elseif strcmp(user_input, 'hint')
            [row, col, num] = find_hint(sudoku_grid); % finds a blank spot that can be filled by a hint
            if row == -1 % no blank spots found
                disp('No hints available. Congratulations! You have won the game!!');
            else
                sudoku_grid(row, col) = num; % fills in a number
                disp('Updated Grid (includes hint):'); % new title
                display_sudoku(sudoku_grid); % displays updated grid
            end
        elseif strcmp(user_input, 'solve it for me')
            solve_sudoku(sudoku_grid); % solves the puzzle
        else
            disp('Invalid input. Please type "hint," "solve it for me," or "exit" to continue.'); % indicates that user must choose one of the two valid options to continue (either "hint" or "exit")
        end
    end

function sudoku_grid = Sudoku_Proj_CLPS0950()
    num_of_blanks = [20,30,40,50,60]; % possible number of blanks

    sudoku_difficulty = input('Which level of difficulty would you like to select? Please enter a number from 1-5. (1: a two year old could do this, 2: easy, 3: medium, 4: hard, 5: DANGER!!) \n'); % prompts user to select difficulty level 
    if sudoku_difficulty >= 1 && sudoku_difficulty <= 5 % defines range of valid difficulty levels (1-5)
       difficulty_level = num_of_blanks(sudoku_difficulty); % difficulty of puzzle depends on number of blanks within puzzle
    else
       fprintf('Invalid selection. Defaulting to medium difficulty.\n') % gives user puzzle of medium difficulty (3) if invalid choice (outside the range of 1-5) is selected
       difficulty_level = num_of_blanks(3);
    end

    sudoku_grid = generate_sudoku(); % generates sudoku grid
    sudoku_grid = create_blanks(sudoku_grid, difficulty_level); % creates blanks in grid based on user's selected difficulty level
end

function sudoku_grid = generate_sudoku()
    sudoku_grid = zeros(9); % initialization of grid
    base_grid = reshape(randperm(9), [3,3]); % generates random block of dimensions 3 by 3
   
    % creates first three rows using row shifting
    sudoku_grid(1:3, 1:3) = base_grid; 
    sudoku_grid(1:3, 4:6) = circshift(base_grid, -1, 1);
    sudoku_grid(1:3, 7:9) = circshift(base_grid, -2, 1);

    % creates next six rows using column shifting
    sudoku_grid(4:6, :) = circshift(sudoku_grid(1:3, :), -1, 2);
    sudoku_grid(7:9, :) = circshift(sudoku_grid(1:3, :), -2, 2);
end 

function sudoku_grid = create_blanks(sudoku_grid, count)
    indices = randperm(81, count); % finds random indices for blanks
    for ii = 1:length(indices)
        row = ceil(indices(ii) / 9);
        col = mod(indices(ii) - 1, 9) + 1;
        sudoku_grid(row, col) = 0; % puts blanks in cells
    end
end

function display_sudoku(sudoku_grid)
    for ii = 1:9
        if mod(ii-1,3) == 0 && ii > 1
            fprintf('---------------------\n'); % creates horizontal lines between rows 3 and 4, and between rows 6 and 7
        end
        for jj = 1:9
            if mod(jj-1,3) == 0 && jj > 1
                fprintf('| '); % creates vertical lines between columns 3 and 4, and between columns 6 and 7
            end
            if sudoku_grid(ii, jj) == 0 
                fprintf('. '); % displays zeros (blanks) as dots
            else
                fprintf('%d ', sudoku_grid(ii, jj)); % displays a number in any cell that is not blank
            end
        end
        fprintf('\n'); % continues to next row after all columns within one row are printed
    end
end

% code for hint component
function [row, col, num] = find_hint(grid)
    for row = 1:9
        for col = 1:9
            if grid(row, col) == 0 % checks for empty cell
                possible_numbers = find_possible_numbers(grid, row, col); % finds all possible (valid) numbers (1-9) that could fill each empty cell
                if ~isempty(possible_numbers) % only fills in number if there are possible numbers that can be used to fill the cell
                    num = possible_numbers(1); % takes the first possible number from the set of all valid numbers and fills in the cell with that number
                    return;
                end
            end
        end
    end
    row = -1; col = -1; num = -1; % no hint found
end

function possible_numbers = find_possible_numbers(grid, row, col)
    all_numbers = 1:9;
    used_numbers = unique([grid(row, :), grid(:, col)', reshape(grid(3*floor((row-1)/3) + (1:3), 3*floor((col-1)/3) + (1:3)), 1, [])]); % identifies all used numbers to ensure that numbers are not repeated within a row, column, or 3 by 3 subgrid
    possible_numbers = setdiff(all_numbers, used_numbers); % identifies all possible numbers (those that have not been used within a column, row, or subgrid yet)
end

% code for solver component
function valid = is_valid(board, row, col, num) 
    if any(board(row, :) == num) % checks to see if number is in row
        valid = false; % number is not placed if already in row
        return;
    end
    if any(board(:, col) == num) % checks to see if number is in column
        valid = false; % number is not placed if already in column
        return;
    end
    
    % defines subgrid
    start_row = floor((row - 1) / 3) * 3 + 1;
    start_col = floor((col - 1) / 3) * 3 + 1;
    subgrid = board(start_row:start_row+2, start_col:start_col+2);
    
    if any(subgrid(:) == num) % checks to see if number is in 3x3 subgrid
        valid = false; % number is not placed if already in subgrid
        return;
    end
    
    valid = true; % number may be placed if not already in row, column, or subgrid
end

function solved = solve_sudoku(grid)
    [row, col] = find(grid == 0, 1); % checks for empty cell
    if isempty(row)  % puzzle is solved when "row" variable does not store the location of any more empty cells
        solved = true;  % indicates that puzzle is solved
        disp('Completed Sudoku Grid:');
        display_sudoku(grid);  % displays completed grid
        return;
    end
    for num = 1:9
        if is_valid(grid, row, col, num)
            grid(row, col) = num;  % fills in a number
            if solve_sudoku(grid) % recursively solves puzzle
                solved = true;  % indicates that puzzle is solved
                return;
            end
            grid(row, col) = 0; % backtracking if no valid number is found
        end
    end
    solved = false;  % indicates that no valid number can be used within grid
end