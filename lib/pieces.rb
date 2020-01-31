class Piece
    attr_reader :color, :type, :symbol
    attr_accessor :counter
    def initialize(color)
        @color = color
        @type = set_type
        @counter = 0
        @symbol = set_symbol
    end

    def set_type
        return nil
    end

    def set_symbol
        return nil
    end
end

class Pawn < Piece
    attr_accessor :en_passant

    def set_type
        @type = "pawn"
    end

    def set_symbol
        color == :white ? "♟" : "♙"
    end

    def can_promote?(index, board)
        i = index[0]
        if (@color == :white && i == 7)
            return true
        elsif (@color == :black && i == 0)
            return true
        end
        return false
    end 

    def double?(board)
        last = board.moves[-1]
        if last[0] == self && (last[1][0] - last[2][0]).abs == 2
            return true
        end
        return false
    end

    def valid_moves(start, board)
        moves = []
        i = start[0]
        j = start[1] 
        if @color == :white
            if i < 7
                moves << [i + 1, j] if !board.board[i+1, j].occupied?
                if i == 1
                    moves << [i + 2, j]
                end
                if j < 7 
                    if board.board[i + 1, j + 1].occupied? && board.board[i+1,j+1].piece.color == :black
                        moves << [i + 1, j + 1]
                    end
                    if board.board[i,j+1].occupied? && board.board[i,j+1].piece.color == :black && 
                        board.board[i,j+1].piece.type == "pawn"
                        if board.board[i,j+1].piece.double?(board)
                            moves << [i + 1, j + 1]
                            self.en_passant = true
                        end
                    end
                end
                if j > 0 
                    if board.board[i + 1, j - 1].occupied? && board.board[i+1,j-1].piece.color == :black
                        moves << [i + 1, j - 1]
                    end
                    if board.board[i,j-1].occupied? && board.board[i,j-1].piece.color == :black && 
                        board.board[i,j-1].piece.type == "pawn"
                        if board.board[i,j-1].piece.double?(board)
                            moves << [i + 1, j - 1]
                            self.en_passant = true
                        end
                    end
                end
            end
        elsif @color == :black
            if i > 0
                moves << [i - 1, j] if !board.board[i-1, j].occupied?
                if i == 6
                    moves << [i - 2, j]
                end
                if j < 7 
                    if board.board[i - 1, j + 1].occupied? && board.board[i-1,j+1].piece.color == :white
                        moves << [i - 1, j + 1]
                    end
                    if board.board[i,j+1].occupied? && board.board[i,j+1].piece.color == :white && 
                        board.board[i,j+1].piece.type == "pawn"
                        if board.board[i,j+1].piece.double?(board)
                            moves << [i - 1, j + 1]
                            self.en_passant = true
                        end
                    end
                end
                if j > 0 
                    if board.board[i - 1, j - 1].occupied? && board.board[i-1,j-1].piece.color == :white
                        moves << [i - 1, j - 1]
                    end
                    if board.board[i,j-1].occupied? && board.board[i,j-1].piece.color == :white && 
                        board.board[i,j-1].piece.type == "pawn"
                        if board.board[i,j-1].piece.double?(board)
                            moves << [i - 1, j - 1]
                            self.en_passant = true
                        end
                    end
                end
            end
        end
        moves
    end
end

class Rook < Piece

    def set_type
        @type = "rook"
    end

    def set_symbol
        color == :white ? "♜" : "♖"
    end

    def valid_moves(start, board)
        moves = []
        i = start[0]
        j = start[1]
        you = board.board[i,j].piece
        row = i
        column = j
        while row < 7
            row += 1
            if board.board[row, j].occupied? 
                if you.color != board.board[row, j].piece.color 
                    moves << [row, j]
                end
                break
            else
                moves << [row, j]
            end
        end
        while column < 7
            column += 1
            if board.board[i, column].occupied?
                if you.color != board.board[i, column].piece.color
                    moves << [i, column]
                end
                break
            else
                moves << [i, column]
            end
        end
        row = i
        column = j
        while row > 0
            row -= 1
            if board.board[row, j].occupied? 
                if you.color != board.board[row, j].piece.color 
                    moves << [row, j]
                end
                break
            else
                moves << [row, j]
            end
        end
        while column > 0
            column -= 1
            if board.board[i, column].occupied?
                if you.color != board.board[i, column].piece.color
                    moves << [i, column]
                end
                break
            else
                moves << [i, column]
            end
        end
        return moves
    end

end

class Bishop < Piece

    def set_type
        @type = "bishop"
    end

    def set_symbol
        color == :white ? "♝" : "♗"
    end

    def valid_moves(start, board)
        moves = []
        i = start[0]
        j = start[1]
        you = board.board[i, j].piece
        row = i
        column = j
        while row < 7 && column < 7
            row += 1
            column += 1
            if board.board[row, column].occupied?
                if you.color != board.board[row, column].piece.color
                    moves << [row, column]
                end
                break
            else
                moves << [row, column]
            end
        end
        row = i
        column = j
        while row < 7 && column > 0
            row += 1
            column -= 1
            if board.board[row, column].occupied?
                if you.color != board.board[row, column].piece.color
                    moves << [row, column]
                end
                break
            else
                moves << [row, column]
            end
        end
        row = i
        column = j
        while row > 0 && column < 7
            row -= 1
            column += 1
            if board.board[row, column].occupied?
                if you.color != board.board[row, column].piece.color
                    moves << [row, column]
                end
                break
            else
                moves << [row, column]
            end
        end
        row = i
        column = j
        while row > 0 && column > 0
            row -= 1
            column -= 1
            if board.board[row, column].occupied?
                if you.color != board.board[row, column].piece.color
                    moves << [row, column]
                end
                break
            else
                moves << [row, column]
            end
        end
        return moves
    end

end

class Knight < Piece

    def set_type
        @type = "knight"
    end

    def set_symbol
        color == :white ? "♞" : "♘"
    end


    def valid_moves(start, board)
        i = start[0]
        j = start[1]
        you = board.board[i,j].piece
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
        moves = moves.select {|move| (!board.board[move[0], move[1]].occupied?) || 
                                        (board.board[move[0], move[1]].occupied? && 
                                        you.color != board.board[move[0], move[1]].piece.color)}
        return moves
    end

end

class Queen < Piece

    def set_type
        @type = "queen"
    end

    def set_symbol
        color == :white ? "♛" : "♕"
    end

    def valid_moves(start, board)
        return rook_moves(start, board) + bishop_moves(start, board)
    end

    def rook_moves(start, board)
        moves = []
        i = start[0]
        j = start[1]
        you = board.board[i,j].piece
        row = i
        column = j
        while row < 7
            row += 1
            if board.board[row, j].occupied? 
                if you.color != board.board[row, j].piece.color 
                    moves << [row, j]
                end
                break
            else
                moves << [row, j]
            end
        end
        while column < 7
            column += 1
            if board.board[i, column].occupied?
                if you.color != board.board[i, column].piece.color
                    moves << [i, column]
                end
                break
            else
                moves << [i, column]
            end
        end
        row = i
        column = j
        while row > 0
            row -= 1
            if board.board[row, j].occupied? 
                if you.color != board.board[row, j].piece.color 
                    moves << [row, j]
                end
                break
            else
                moves << [row, j]
            end
        end
        while column > 0
            column -= 1
            if board.board[i, column].occupied?
                if you.color != board.board[i, column].piece.color
                    moves << [i, column]
                end
                break
            else
                moves << [i, column]
            end
        end
        return moves
    end

    def bishop_moves(start, board)
        moves = []
        i = start[0]
        j = start[1]
        you = board.board[i, j].piece
        row = i
        column = j
        while row < 7 && column < 7
            row += 1
            column += 1
            if board.board[row, column].occupied?
                if you.color != board.board[row, column].piece.color
                    moves << [row, column]
                end
                break
            else
                moves << [row, column]
            end
        end
        row = i
        column = j
        while row < 7 && column > 0
            row += 1
            column -= 1
            if board.board[row, column].occupied?
                if you.color != board.board[row, column].piece.color
                    moves << [row, column]
                end
                break
            else
                moves << [row, column]
            end
        end
        row = i
        column = j
        while row > 0 && column < 7
            row -= 1
            column += 1
            if board.board[row, column].occupied?
                if you.color != board.board[row, column].piece.color
                    moves << [row, column]
                end
                break
            else
                moves << [row, column]
            end
        end
        row = i
        column = j
        while row > 0 && column > 0
            row -= 1
            column -= 1
            if board.board[row, column].occupied?
                if you.color != board.board[row, column].piece.color
                    moves << [row, column]
                end
                break
            else
                moves << [row, column]
            end
        end
        return moves
    end


end

class King < Piece

    def set_type
        @type = "king"
    end

    def set_symbol
        color == :white ? "♚" : "♔"
    end

    def valid_moves(start, board)
        i = start[0]
        j = start[1]
        you = board.board[i, j].piece
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
        moves = moves.select {|move| (!board.board[move[0], move[1]].occupied?) || 
                                        (board.board[move[0], move[1]].occupied? && 
                                        you.color != board.board[move[0], move[1]].piece.color)}
        return moves
    end

end