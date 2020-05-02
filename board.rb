require_relative 'tile.rb'

class Board
    attr_reader :grid

    def initialize(size = 9)
        @grid = empty_grid(size)
    end
    
    def [](*pos)
        x, y = pos
        @grid[x][y]
    end

    def empty_grid(size)
        Array.new(size) { Array.new(size) { Tile.new(self) } }
    end

    def won?
        @grid.all? do |row| 
            row.all? { |tile| tile.hidden == false || tile.bomb == true }
        end
    end
end