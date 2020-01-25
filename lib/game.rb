require_relative "board"
require_relative "pieces"

class Game
    attr_accessor :counter
    def initialize
        @counter = 0
    end

    def checkmate?(board)
        white_pieces = board.find_pieces[:white]
        black_pieces = board.find_pieces[:black]
        white_counter = []
        white_pieces.each do |spot|
            index = board.board.find_index(spot)
            i = index[0]
            j = index[1]
            you = board.board[i, j].piece
            valid_moves = you.valid_moves([i,j], board)
            valid_moves.each do |move|
                original_piece = board.board[move[0], move[1]].piece
                board.board[move[0], move[1]].piece = you
                board.board[i, j].piece = nil
                if board.check? == -1
                    # puts "Les regalaste un jaque"
                    white_counter << -1
                else
                    white_counter << 0
                end
                board.board[move[0], move[1]].piece = original_piece
                board.board[i, j].piece = you
            end
        end
        # p white_counter
        black_counter = []
        black_pieces.each do |spot|
            index = board.board.find_index(spot)
            i = index[0]
            j = index[1]
            you = board.board[i, j].piece
            valid_moves = you.valid_moves([i,j], board)
            valid_moves.each do |move|
                original_piece = board.board[move[0], move[1]].piece
                board.board[move[0], move[1]].piece = you
                board.board[i, j].piece = nil
                if board.check? == 1
                    # puts "Les regalaste un jaque"
                    black_counter << -1
                else
                    black_counter << 0
                end
                board.board[move[0], move[1]].piece = original_piece
                board.board[i, j].piece = you
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
end

# game = Game.new
# board = Board.new
# puts board.render
# Jaque mate pastor

# board.move([1,0], [2,0])
# board.move([6,4], [5,4])
# board.move([1,7], [2,7])
# board.move([7,3], [5,5])
# board.move([7,5], [4,2])
# board.move([5,5], [1,5])

# puts "\n"
# puts board.render
# p game.checkmate?(board)