require "./lib/board"
require "./lib/pieces"
require "./lib/players"
require "./lib/game"

board = Board.new
game = Game.new(board)
player_one = WhitePlayer.new
player_two = BlackPlayer.new


while true
    move = false
    while !move 
        puts board.render
        print "White moves: "
        spots = gets.chomp
        if spots == "shortcastle"
            move = board.castle("short", player_one.color)
        elsif spots == "longcastle"
            move = board.castle("long", player_one.color)
        else
            puts "\n"
            move = player_one.move(spots, board)
        end
    end
    puts "\n"
    break if game.end?
    move = false
    while !move
        puts board.render
        print "Black moves: "
        spots = gets.chomp
        if spots == "shortcastle"
            move = board.castle("short", player_two.color)
        elsif spots == "longcastle"
            move = board.castle("long", player_two.color)
        else
            puts "\n"
            move = player_two.move(spots, board)
        end
    end
    puts "\n"
    break if game.end?
end