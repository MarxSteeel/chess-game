require "matrix"
require_relative "pieces"
require "colorize"

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
                puts "Les regalaste un jaque"
                return -1
            end
        end
        self.board[finish[0], finish[1]].piece.counter += 1
        return 0
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

    def checkmate?
        white_pieces = find_pieces[:white]
        black_pieces = find_pieces[:black]
        white_counter = []
        white_pieces.each do |spot|
            index = self.board.find_index(spot)
            i = index[0]
            j = index[1]
            you = self.board[i, j].piece
            valid_moves = you.valid_moves([i,j], self)
            valid_moves.each do |move|
                original_piece = self.board[move[0], move[1]].piece
                self.board[move[0], move[1]].piece = you
                self.board[i, j].piece = nil
                if self.check? == -1
                    # puts "Les regalaste un jaque"
                    white_counter << -1
                else
                    white_counter << 0
                end
                self.board[move[0], move[1]].piece = original_piece
                self.board[i, j].piece = you
            end
        end
        # p white_counter
        black_counter = []
        black_pieces.each do |spot|
            index = self.board.find_index(spot)
            i = index[0]
            j = index[1]
            you = self.board[i, j].piece
            valid_moves = you.valid_moves([i,j], self)
            valid_moves.each do |move|
                original_piece = self.board[move[0], move[1]].piece
                self.board[move[0], move[1]].piece = you
                self.board[i, j].piece = nil
                if self.check? == 1
                    # puts "Les regalaste un jaque"
                    black_counter << -1
                else
                    black_counter << 0
                end
                self.board[move[0], move[1]].piece = original_piece
                self.board[i, j].piece = you
            end
        end
        # p black_counter
        if !white_counter.include?(0)
            return -1 #Black wins
        elsif !black_counter.include?(0)
            return 1 #White wins
        else
            return 0
        end
    end

    def promote(spot, new_piece)
        index = self.board.find_index(spot)
        i = index[0]
        j = index[1]
        color = self.board[i,j].piece.color
        if new_piece == "queen"
            self.board[i,j].piece = Queen.new(color)
        elsif new_piece == "knight"
            self.board[i,j].piece = Knight.new(color)
        elsif new_piece == "rook"
            self.board[i,j].piece = Rook.new(color)
        elsif new_piece == "bishop"
            self.board[i,j].piece = Bishop.new(color)
        end
        return
    end

    def castle(type, color)
        begin
            if color == :white
                i = 0
            elsif color == :black
                i = 7
            end
            king = self.board[i,4].piece
            if type == "short"
                rook = self.board[i,7].piece
                knight = self.board[i,6]
                bishop = self.board[i,5]
            elsif type == "long"
                rook = self.board[i,0].piece
                knight = self.board[i,1]
                bishop = self.board[i,2]
                queen = self.board[i,3]
            end
            if king.counter == 0 && rook.counter == 0 && !knight.occupied? && !bishop.occupied?
                if type == "short"
                    self.move([i,4], [i,5])
                    self.move([i,5], [i,6])
                    self.board[i,7].piece = nil
                    self.board[i,5].piece = Rook.new(color)
                    king.counter -= 2
                    self.board[i,5].piece.counter += 1
                    return 1
                elsif type == "long" && !queen.occupied?
                    self.move([i,4], [i,3])
                    self.move([i,3], [i,2])
                    self.board[i,0].piece = nil
                    self.board[i,3].piece = Rook.new(color)
                    king.counter -= 2
                    self.board[0,3].piece.counter += 1
                    return 1
                end
            end
        rescue
            return 0
        end
        return 0
    end
    
    def render
        board_string = ""
        row = 7
        while row > -1
            self.board.row(row).each_with_index do |spot, i|
                if (i + row).even? || (i + row) == 0
                    if spot.occupied?
                        board_string += self.board.row(row)[i].piece.symbol.colorize(:background => :light_black)
                    else
                        board_string += " ".colorize(:background => :light_black)
                    end
                else
                    if spot.occupied?
                        board_string += self.board.row(row)[i].piece.symbol.colorize(:background => :black)
                    else
                        board_string += " ".colorize(:background => :black)
                    end
                end
            end
            board_string += "\n"
            row -= 1
        end
        return board_string
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

# Jaque mate pastor

# board.move([1,0], [2,0])
# board.move([6,4], [5,4])
# board.move([1,7], [2,7])
# board.move([7,3], [5,5])
# board.move([7,5], [4,2])
# board.move([5,5], [1,5])


# board.move([6,6], [5,6])
# board.move([7,5], [6,6])
# board.move([7,6], [5,5])
# board.move([7,7], [7,6])
# board.move([7,6], [7,7])

# pieces = pieces.select {|spot| spot.piece.type == "king"}
# board.promote(board.board[1,0], "queen")
# p board.castle("short", :black)
pieces = board.board.map {|spot| spot.piece}
# p board.board[1,5].piece.counter
# puts board.board[0,0].piece.symbol.colorize(:background => :light_black)
p pieces
p board.check?
p board.checkmate?
puts board.render
