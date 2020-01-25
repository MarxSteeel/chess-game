require_relative "board"
require_relative "pieces"

class Player
    attr_reader :color
    def initialize
        @color = nil
    end

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
end

class WhitePlayer < Player
    def initialize
        @color = :white
    end
end

class BlackPlayer < Player
    def initialize
        @color = :black
    end
end

# player_one = WhitePlayer.new
# board = Board.new
# p player_one.can_move?([0,0], board)