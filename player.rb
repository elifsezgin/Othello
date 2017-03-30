class Player
  attr_accessor :color, :is_computer
  def initialize(game, color, is_computer)
    @game = game
    @color = color
    @is_computer = is_computer
  end

  def play_turn
    row = (0..7).to_a.sample
    col = (0..7).to_a.sample
    pos = [row, col]
    until @game.valid_directions(pos, @color)
      row = (0..7).to_a.sample
      col = (0..7).to_a.sample
      pos = [row, col]
    end
    pos
  end


end
