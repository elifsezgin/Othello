class Board
  attr_accessor :board
  def initialize
    @board = Array.new(8) {  Array.new(8) }
    @board[3][3], @board[4][4] = 'W', 'W'
    @board[3][4], @board[4][3] = 'B', 'B'
  end

  def display
    @board.each do |row|
      row.each do |cell|
        case cell
        when nil
          print '-'
        when 'W'
          print 'W'
        when 'B'
          print 'B'
        end
        print ' '
      end
      print "\n"
    end
  end

  def [](pos)
    @board[pos[0]][pos[1]]
  end

  def []=(pos, value)
    @board[pos[0]][pos[1]] = value
  end
end
