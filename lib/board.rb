require "matrix"
require_relative "pieces"

class Spot
    attr_accessor :piece
    def initialize(piece=nil)
        @piece = piece
    end

    def occupied?
        piece.nil? ? false : true
    end
end

class Board
    attr_reader :board
    def initialize
        @board = create_board
    end

    private

    def create_board
        array = []
        i = 1
        while i < 9
            row = []
            j = 1
            while j < 9
                spot = Spot.new
                row << spot
                j += 1
            end
            array << row
            i += 1
        end
        matrix = Matrix[array[0], array[1], array[2], array[3], array[4], array[5], array[6], array[7]]
        board = assign_pieces(matrix)
        return board
    end

    def assign_pieces(matrix)
        (matrix.row(1)).each do |spot|
            spot.piece = Pawn.new(:white)
        end
        (matrix.row(6)).each do |spot|
            spot.piece = Pawn.new(:black)
        end
        matrix[0,0].piece = Rook.new(:white)
        matrix[0,1].piece = Knight.new(:white)
        matrix[0,2].piece = Bishop.new(:white)
        matrix[0,3].piece = Queen.new(:white)
        matrix[0,4].piece = King.new(:white)
        matrix[0,5].piece = Bishop.new(:white)
        matrix[0,6].piece = Knight.new(:white)
        matrix[0,7].piece = Rook.new(:white)
        matrix[7,0].piece = Rook.new(:black)
        matrix[7,1].piece = Knight.new(:black)
        matrix[7,2].piece = Bishop.new(:black)
        matrix[7,3].piece = Queen.new(:black)
        matrix[7,4].piece = King.new(:black)
        matrix[7,5].piece = Bishop.new(:black)
        matrix[7,6].piece = Knight.new(:black)
        matrix[7,7].piece = Rook.new(:black)
        return matrix
    end
end

board = Board.new
p board.board.map {|spot| spot.piece}
p board.board[1,0].piece.valid_moves([1,0], board)