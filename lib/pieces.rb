class Piece
    attr_reader :color
    def initialize(color)
        @color = color
    end
end

class Pawn < Piece
    def valid_moves(start, board)
        moves = []
        i = start[0]
        j = start[1]
        if @color == :white
            moves << [i + 1, j]
            if i == 1
                moves << [i + 2, j]
            end
            if board.board[i + 1, j + 1].occupied? && board.board[i+1,j+1].piece.color == :black
                moves << [i + 1, j + 1]
            elsif board.board[i + 1, j - 1].occupied? && board.board[i+1,j-1].piece.color == :black
                moves << [i + 1, j - 1]
            end
        elsif @color == :black
            moves << [i - 1, j]
            if i == 6
                moves << [i - 2, j]
            end
            if board.board[i - 1, j + 1].occupied? && board.board[i-1,j+1].piece.color == :white
                moves << [i - 1, j + 1]
            elsif board.board[i - 1, j - 1].occupied? && board.board[i-1,j-1].piece.color == :white
                moves << [i - 1, j - 1]
            end
        end
        moves
    end
end

class Rook < Piece

end

class Bishop < Piece

end

class Knight < Piece

end

class Queen < Piece

end

class King < Piece

end