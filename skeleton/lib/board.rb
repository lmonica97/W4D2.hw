class Board
  attr_accessor :cups, :player1, :player2

  def initialize(name1, name2)
    @cups = Array.new(14) {Array.new}
    @player1 = name1
    @player2 = name2
    place_stones
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    @cups.each_with_index do |cup, e|
      if e == 6 || e == 13
        @cups[e] = []
      else
        i = 0
        while i < 4
          cup << :stone
          i += 1
        end
      end
    end
  end

  def valid_move?(start_pos)
    if start_pos > @cups.length
      raise RuntimeError.new("Invalid starting cup")
    end
    if @cups[start_pos].length == 0
      raise RuntimeError.new("Starting cup is empty")
    end
  end

  def make_move(start_pos, current_player_name)
    stones = @cups[start_pos]
    @cups[start_pos].clear
    i = start_pos + 1
    until stones.empty?
      i += 1 
      i = 0 if i > 13

      if i == 6
        @cups[6] << stones.pop if current_player_name == @name1
      elsif i == 13
        @cups[13] << stones.pop if current_player_name == @name2
      else
        @cups[i] << stones.pop
      end
    end
    render
    next_turn(i)
  end

  def next_turn(ending_cup_idx)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
    if @cups[ending_cup_idx].count == 0
      :switch
  
    elsif ending_cup_idx == 6 || ending_cup_idx == 13
      :prompt
    else
      ending_cup_idx
    end

  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    @cups[0..5].all? {|cup| cup.empty?} || @cups[6..12].all? {|cup| cup.empty?}
  end

  def winner
    player1_count = @cups[6].count
    player2_count = @cups[13].count

    if player1_count == player2_count
      :draw
    else
      if player1_count > player2_count
        @name1
      else
        @name2
      end
    end
  end
end
