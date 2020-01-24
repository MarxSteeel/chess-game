require "matrix"
require_relative "pieces"

class Spot
    attr_accessor :piece
    def initialize(piece=nil)
        @piece = piece
    end

    def occupied?
        !piece.nil?
    end
end

class Board
    attr_accessor :board
    def initialize
        @board = create_board
    end

    def move(start, finish)
        i = start[0]
        j = start[1]
        you = self.board[i, j].piece
        valid_moves = you.valid_moves([i,j], self)
        if valid_moves.include?(finish)
            original_piece = self.board[finish[0], finish[1]].piece
            self.board[finish[0], finish[1]].piece = you
            self.board[i, j].piece = nil
            if (you.color == :white && self.check? == -1) || (you.color == :black && self.check? == 1)
                self.board[finish[0], finish[1]].piece = original_piece
                self.board[i, j].piece = you
                puts "La cagaste"
                return -1
            end
        end
        return
    end

    def check?
        kings = find_kings
        white_king = kings.select {|king| king.piece.color == :white}
        black_king = kings.select {|king| king.piece.color == :black}
        white_pieces = find_pieces[:white]
        black_pieces = find_pieces[:black]
        white_moves = []
        white_pieces.each do |spot|
            index = self.board.find_index(spot)
            white_moves += spot.piece.valid_moves(index, self)
        end
        black_moves = []
        black_pieces.each do |spot|
            index = self.board.find_index(spot)
            black_moves += spot.piece.valid_moves(index,self)
        end
        white_king_index = self.board.find_index(white_king[0])
        black_king_index = self.board.find_index(black_king[0])
        if white_moves.include?(black_king_index) 
            return 1 #black king in check
        elsif black_moves.include?(white_king_index)
            return -1 #white king in check
        end
        return 0
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

    def find_pieces
        occupied_spots = self.board.select {|spot| spot.occupied?}
        white_pieces = occupied_spots.select {|spot| spot.piece.color == :white}
        black_pieces = occupied_spots.select {|spot| spot.piece.color == :black}
        return {:white => white_pieces, :black => black_pieces}
    end

    def find_kings
        occupied_spots = self.board.select {|spot| spot.occupied?}
        kings = occupied_spots.select {|spot| spot.piece.type == "king"}
        return kings
    end
    
end

board = Board.new
# board.board.column(0).each_with_index do |elm, i|
#     p i
# end
# p board.board[0,0].piece.valid_moves([0,0], board)
board.move([6,2], [5,2])
board.move([7,3], [4,0])
board.move([1,3], [2,3])
pieces = board.board.map {|spot| spot.piece}
# pieces = pieces.select {|spot| spot.piece.type == "king"}
p pieces
p board.check?
