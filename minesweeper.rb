require_relative 'board.rb'
require 'yaml'
require 'byebug'

class Minesweeper

    def initialize(size = 9)
        @board = Board.new(size)
        @bombed = false
        @flag_mode = false
    end

    def run
        until @board.won? || @bombed == true
            refresh_board
            play_turn
            if @bombed == true
                refresh_board
                puts
                puts "You hit a bomb! You lose!!"
            end
        end

        if @board.won?
            refresh_board
            puts "Congratulations! You cleared the board!"
        end
    end

    def flag_mode
        @flag_mode = true
        while @flag_mode == true
            flag_prompt
            input = gets.chomp
            next if exit_flag_mode?(input)
            flag_pos = parse_pos(input)
            toggle_flag_if_valid(flag_pos)
            refresh_board
        end
    end
    
    def exit_flag_mode?(input)
        if input.downcase == 'f'
            @flag_mode = false
            true
        else
            false
        end
    end
    
    def toggle_flag_if_valid(flag_pos)
        if @board.valid_pos?(flag_pos) && @board[flag_pos].hidden == true
            @board[flag_pos].toggle_flag
        else
            puts "Must be a valid, hidden tile. Try again."
        end
    end

    def save_game
        system("clear")
        puts "What would you like to call your saved game? (No spaces please)"
        saved_game_name = gets.chomp
        saved_game = self.to_yaml
        File.open("saved_games/#{saved_game_name}", "w+") { |f| f.write(saved_game) }
    end
    
    def get_pos
        pos = nil
        
        until pos && @board.valid_pos?(pos)
            prompt
            input = gets.chomp
            

            if enter_flag_mode?(input)
                flag_mode
                next
            end

            if save_game?(input)
                save_game
                break # NEED TO STOP GAME RUNNING AFTER SAVED
            end
            
            pos = check_pos(input)
        end
        pos
    end

    def save_game?(input)
        input.downcase == 's' ? true : false
    end
    
    def enter_flag_mode?(input)
        input.downcase == 'f' ? true : false
    end
    
    def refresh_board
        system("clear")
        @board.render
    end
    
    def reveal_tiles(pos)
        if @board[pos].neighbor_bomb_count == 0
            @board[pos].neighbors.each do |n|
                if @board[n].hidden == true
                    @board[n].reveal
                    reveal_tiles(n)
                end
            end
        end
    end
    
    def check_pos(input)
        pos = parse_pos(input)
        
        if !@board.valid_pos?(pos) || @board[pos].is_flagged?
            puts "You can only reveal a hidden, unflagged tile on the board. Try again."
            return nil
        end  
        pos
    end
    
    def play_turn
        guess_pos = get_pos
        @board[guess_pos].reveal
        
        if @board[guess_pos].is_bomb?
            @bombed = true
        else
            reveal_tiles(guess_pos) 
        end
    end
    
    def prompt
        puts
        puts "Enter 'f' to switch to flag mode or 's' to save. Otherwise, "
        puts "enter the position of the tile that you want to reveal: "
        puts
    end
    
    def flag_prompt
        puts
        puts "FLAG MODE (enter 'f' again to exit flag mode)"
        puts "Which hidden tile would you like to flag or unflag?"
        puts
    end

    def parse_pos(pos)
        begin
            pos.split(",").map { |n| Integer(n) }
        rescue => error
            puts error
            puts "Position must be 2 numbers separated by a comma."
            return nil
        end
    end
end

game = Minesweeper.new
game.run