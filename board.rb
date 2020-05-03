require_relative 'tile.rb'
require 'byebug'

class Board
    attr_reader :grid

    def initialize(size = 9)
        @grid = empty_grid(size)
        seed_board(size)
    end
    
    def [](pos)
        x, y = pos
        @grid[x][y]
    end
    
    def seed_board(percent = 25)
        num_bombs = (board_size ** 2 * (percent / 100.0)).round
        all_positions = []
        
        @grid.each_with_index do |row, x|
            row.each_with_index do |tile, y|
                all_positions << [x, y]
            end
        end
        
        all_positions.sample(num_bombs).each do |pos|
            self[pos].bomb = true # MAKE SURE ONLY THIS CLASS CAN ACCESS BOMB ATTR
        end
    end

    def valid_pos?(pos)
        pos.length == 2 &&
            pos.all? { |coord| coord.between?(0, board_size - 1) }
    end

    def board_size
        @grid.length
    end

    def empty_grid(size)
        Array.new(size) { Array.new(size) { Tile.new(self) } }
    end

    def render_header
        print "  "
        (0...board_size).each { |n| print "#{n} " }
        puts
    end

    def render
        render_header
        @grid.each_with_index do |row, i|
            print "#{i} "
            row.each { |tile| print "#{tile} " }
            puts
        end
    end

    def won?
        @grid.all? do |row| 
            row.all? { |tile| tile.hidden == false || tile.bomb == true }
        end
    end
end