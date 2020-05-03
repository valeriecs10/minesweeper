require_relative 'board.rb'
require 'byebug'

class Minesweeper

    attr_reader :board # DELETE AFTER TESTING
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
        puts "Enter the position of the tile that you want to reveal: "
        puts
    end

    def parse_pos(pos)
        pos.split(",").map { |n| Integer(n) }
    end
end