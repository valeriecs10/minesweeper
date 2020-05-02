require_relative 'board.rb'
require 'byebug'

class Tile
    attr_reader :bomb
    attr_accessor :hidden, :flagged, :bomb, :board # DELETE AFTER TESTING

    def initialize(board)
        @hidden = true
        @flagged = false
        @bomb = false
        @board = board
    end

    def to_s
        if @flagged == true && @hidden == true
            "F"
        elsif @hidden == true
            "*"
        elsif @hidden == false && neighbor_bomb_count == 0
            "_"
        else
            neighbor_bomb_count
        end
    end

    def is_bomb?
        @bomb
    end

    def reveal
        @hidden = false
    end

    def toggle_flag
        @flagged ? @flagged = false : @flagged = true
    end

    def neighbor_bomb_count
        neighbors.count { |neighbor| @board[neighbor].bomb == true }
    end

    def neighbors
        x, y = self_pos
        neighbors = [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]]
        neighbors.select { |neighbor| @board.valid_pos?(neighbor) }
    end

    def self_pos
        x = nil
        y = nil
        @board.grid.each_with_index { |row, i| x = i if row.include?(self) }
        @board.grid[x].each_with_index { |tile, i| y = i if tile == self }
        [x, y]
    end
end