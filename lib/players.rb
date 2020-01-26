require_relative "board"
require_relative "pieces"
require_relative "game"

class Player
    attr_reader :color, :dictionary
    def initialize
        @color = set_color
        @dictionary = {"a"=>0, "b"=>1, "c"=>2, "d"=>3, "e"=>4, "f"=>5, "g"=>6, "h"=>7}
    end

    def set_color
        return nil
    end

    def move(string, board)
        spots = parser(string)
        start = spots[0]
        finish = spots[1]
        if can_move?(start, board)
            i = start[0]
            j = start[1]
            return board.move([i,j], [finish[0], finish[1]])
        else
            return false
        end
    end

    private

    def can_move?(spot, board)
        i = spot[0]
        j = spot[1]
        begin
            color = board.board[i,j].piece.color
            return color == @color
        rescue
            return false
        end
    end

    def parser(string)
        start = []
        finish = []
        start << string[1].to_i - 1
        start << @dictionary[string[0].downcase]
        finish << string[3].to_i - 1
        finish << @dictionary[string[2].downcase]
        return [start, finish]
    end
end

class WhitePlayer < Player
    def set_color
        return :white
    end
end

class BlackPlayer < Player
    def set_color
        return :black
    end
end

# game = Game.new
# player_one = WhitePlayer.new
# board = Board.new
# player_one.move("b1c3", board)
# puts "\n"
# puts board.render
# p game.checkmate?(board)
