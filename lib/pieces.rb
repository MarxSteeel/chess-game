class Piece
    attr_reader :color, :type
    def initialize(color)
        @color = color
        @type = set_type
    end

    def set_type
        return nil
    end
end

class Pawn < Piece

    def set_type
        @type = "pawn"
    end

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

    def set_type
        @type = "rook"
    end

    def valid_moves(start, board)
        moves = []
        i = start[0]
        j = start[1]
        row = i
        column = j
        while row < 7
            row += 1
            board.board[row, j].occupied? ? break : moves << [row, j]
        end
        while column < 7
            column += 1
            board.board[i, column].occupied? ? break : moves << [i, column]
        end
        row = i
        column = j
        while row > 0
            row -= 1
            board.board[row, j].occupied? ? break : moves << [row, j]
        end
        while column > 0
            column -= 1
            board.board[i, column].occupied? ? break : moves << [i, column]
        end
        return moves
    end

end

class Bishop < Piece

    def set_type
        @type = "bishop"
    end

    def valid_moves(start, board)
        moves = []
        i = start[0]
        j = start[1]
        row = i
        column = j
        while row < 7 && column < 7
            row += 1
            column += 1
            board.board[row, column].occupied? ? break : moves << [row, column]
        end
        row = i
        column = j
        while row < 7 && column > 0
            row += 1
            column -= 1
            board.board[row, column].occupied? ? break : moves << [row, column]
        end
        row = i
        column = j
        while row > 0 && column < 7
            row -= 1
            column += 1
            board.board[row, column].occupied? ? break : moves << [row, column]
        end
        row = i
        column = j
        while row > 0 && column > 0
            row -= 1
            column -= 1
            board.board[row, column].occupied? ? break : moves << [row, column]
        end
        return moves
    end

end

class Knight < Piece

    def set_type
        @type = "knight"
    end

    def valid_moves(start, board)
        i = start[0]
        j = start[1]
        first = [i + 1, j + 2] 
        second = [i -1 , j - 2] 
        third = [i - 1, j + 2] 
        fourth = [i + 1, j - 2] 
        fifth = [i + 2, j + 1] 
        sixth = [i - 2, j + 1] 
        seventh = [i + 2, j - 1] 
        eigth = [i - 2, j - 1] 
        moves = [first, second, third, fourth, fifth, sixth, seventh, eigth]
        moves = moves.select {|move| move[0] < 8 && move[0] >= 0 && move[1] < 8 && move[1] >= 0}
        moves = moves.select {|move| !board.board[move[0], move[1]].occupied?}
        return moves
    end

end

class Queen < Piece

    def set_type
        @type = "queen"
    end

    def valid_moves(start, board)
        return rook_moves(start, board) + bishop_moves(start, board)
    end

    def rook_moves(start, board)
        moves = []
        i = start[0]
        j = start[1]
        row = i
        column = j
        while row < 7
            row += 1
            board.board[row, j].occupied? ? break : moves << [row, j]
        end
        while column < 7
            column += 1
            board.board[i, column].occupied? ? break : moves << [i, column]
        end
        row = i
        column = j
        while row > 0
            row -= 1
            board.board[row, j].occupied? ? break : moves << [row, j]
        end
        while column > 0
            column -= 1
            board.board[i, column].occupied? ? break : moves << [i, column]
        end
        return moves
    end

    def bishop_moves(start, board)
        moves = []
        i = start[0]
        j = start[1]
        row = i
        column = j
        while row < 7 && column < 7
            row += 1
            column += 1
            board.board[row, column].occupied? ? break : moves << [row, column]
        end
        row = i
        column = j
        while row < 7 && column > 0
            row += 1
            column -= 1
            board.board[row, column].occupied? ? break : moves << [row, column]
        end
        row = i
        column = j
        while row > 0 && column < 7
            row -= 1
            column += 1
            board.board[row, column].occupied? ? break : moves << [row, column]
        end
        row = i
        column = j
        while row > 0 && column > 0
            row -= 1
            column -= 1
            board.board[row, column].occupied? ? break : moves << [row, column]
        end
        return moves
    end

end

class King < Piece

    def set_type
        @type = "king"
    end

    def valid_moves(start, board)
        i = start[0]
        j = start[1]
        first = [i + 1, j] 
        second = [i + 1 , j + 1] 
        third = [i, j + 1] 
        fourth = [i - 1, j + 1] 
        fifth = [i - 1, j] 
        sixth = [i - 1, j - 1] 
        seventh = [i, j - 1] 
        eigth = [i + 1, j - 1] 
        moves = [first, second, third, fourth, fifth, sixth, seventh, eigth]
        moves = moves.select {|move| move[0] < 8 && move[0] >= 0 && move[1] < 8 && move[1] >= 0}
        moves = moves.select {|move| !board.board[move[0], move[1]].occupied?}
        return moves
    end

end