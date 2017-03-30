require './board.rb'
require './player.rb'
require 'byebug'

class Game
  attr_accessor :board
  def initialize
    @board = Board.new
    @player1 = nil
    @player2 = nil
    @current_player = nil
  end

  def get_move(player)
    puts 'Choose the cell for your disc. esc: 1,2'
    move = gets.chomp
    x, y = move.split(',')
    x, y = x.to_i, y.to_i
    x -= 1
    y -= 1
    [x, y]
  end

  def get_move_computer(player)
    player.play_turn
  end

  def take_turn(pos, player)
    directions = valid_directions(pos, player)
    return false unless directions
    directions.each do |direction|
      dye_one_direction(pos, direction, player)
    end
  end

  def dye_one_direction(start, direction, color)
    @board[start] = color
    row, col = start
    row += direction[0]
    col += direction[1]
    until @board[[row, col]] == color
      @board[[row, col]] = color
      row += direction[0]
      col += direction[1]
    end
  end

  def start
    create_users
    @current_player = @player1
    @board.display
    play
  end

  def create_users
    puts 'W or B'
    color = gets.chomp.upcase
    if color == 'B'
      @player1 = Player.new(self, 'B', false)
      @player2 = Player.new(self, 'W', true)
    else
      @player1 = Player.new(self, 'B', true)
      @player2 = Player.new(self, 'W', false)
    end
  end

  def play
    until game_over?
      pos = @current_player.is_computer ? get_move_computer(@current_player) : get_move(@current_player)
      next unless take_turn(pos, @current_player.color)
      puts "Turn : #{@current_player.color}"
      puts "Move : #{pos[0]+1} / #{pos[1]+1}"
      @current_player = @current_player == @player1 ? @player2 : @player1
      @board.display
    end
  end

  def valid_directions(pos, player)
    return false if @board[pos]
    surroundings_empty = true
    opposite_discs = []
    surroundings(pos).each do |cell|
      if @board[cell]
        surroundings_empty = false
        opposite_discs << cell if @board[cell] != player
      end
    end
    return false if surroundings_empty
    directions = []
    opposite_discs.each do |cell|
      direction = check_direction(cell, pos, player)
      directions << direction if direction
    end
    directions.empty? ? false : directions
  end

  def check_direction(cell, pos, player)
    direction = [cell[0]-pos[0], cell[1]-pos[1]]
    row, col = [cell[0]+direction[0], cell[1]+direction[1]]
    until row < 0 || row > 7 || col < 0 || col > 7
      return direction if @board[[row, col]] == player
      return false unless @board[[row, col]]
      row += direction[0]
      col += direction[1]
    end
  end

  def surroundings(pos)
    directions = [[0, 1], [0, -1], [1, 0], [-1, 0], [1,1], [1, -1], [-1, 1], [-1, -1]]
    surroundings = []
    directions.each do |direction|
      x = pos[0] + direction[0]
      y = pos[1] + direction[1]
      if x < 8 && x >= 0 && y < 8 && y >= 0
        surroundings << [x, y]
      end
    end
    surroundings
  end

  def game_over?
    @board.board.each_with_index do |row, row_idx|
      row.each_with_index do |cell, col_idx|
        if cell == nil
          return false if valid_directions([row_idx, col_idx], @current_player.color)
        end
      end
    end
    puts 'Game over'
    true
  end
end

a = Game.new
a.start
