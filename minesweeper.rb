require_relative 'board.rb'

class Minesweeper
    def initialize(size = 9)
        @board = Board.new(size)
        @bombed = false
    end

     def run
        while !@bombed
            play_turn until @board.won?
            puts "Congratulations! You cleared the board!"
        end
    end

    def get_pos
        pos = nil

        until pos && @board.valid_pos?(pos)
            prompt

            begin
                pos = parse_pos(gets.chomp)
            rescue => error
                puts error
                puts "You can only reveal a valid, hidden tile. Try again."
                puts

                pos = nil
            end
            puts "Position must be 2 numbers separated by a comma. Try again."
        end
        pos
    end

    def play_turn
        guess_pos = get_pos
        if @board[guess_pos].is_bomb?
            @bombed = true
        else
            # FINISH TURN
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