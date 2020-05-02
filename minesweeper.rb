require_relative 'board.rb'

class Minesweeper
    def initialize(size = 9)
        @board = Board.new(size)
        @bombed = false
    end

    def run
        until @board.won? || @bombed == true
            refresh_board
            play_turn
        end
        puts "Congratulations! You cleared the board!" if @board.won?
    end

    def get_pos
        pos = nil

        until pos && @board.valid_pos?(pos)
            prompt

            begin
                pos = parse_pos(gets.chomp)
            rescue => error
                puts error
                puts "Position must be 2 numbers separated by a comma. Try again."
                puts
                
                pos = nil
            end

            if !@board.valid_pos?(pos) 
                puts "You can only reveal a hidden tile on the board. Try again."
                pos = nil
            end
        end
        pos
    end

    def refresh_board
        system("clear")
        @board.render
    end

    def reveal_neighbors(pos)
        @board[pos].neighbors.each do |neighbor| 
            if @board[neighbor].hidden
                @board[neighbor].reveal
                reveal_neighbors(neighbor)
            end
        end
    end

    def play_turn
        guess_pos = get_pos

        if @board[guess_pos].is_bomb?
            @bombed = true
        else
            @board[guess_pos].reveal

            if @board[guess_pos].neighbor_bomb_count == 0
                reveal_neighbors(guess_pos) 
            end
        end

    end

    def prompt
        puts "Enter the position of the tile that you want to reveal: "
        puts
    end

    def parse_pos(pos)
        pos.split(",").map { |n| Integer(n) }
    end
end