module RazzleDazzle
  # Mostly based on http://www.goodmagic.com/websales/midway/razzle.htm
  module Rules
    def self.board
      [
        3, 2, 3, 5, 3, 2, 3, 4, 3, 5, 3, 2, 3, 4, 3,
        4, 5, 4, 2, 4, 3, 4, 3, 4, 2, 4, 5, 4, 1, 2,
        3, 4, 6, 4, 3, 4, 1, 5, 3, 4, 5, 4, 3, 6, 3,
        4, 2, 4, 5, 4, 2, 4, 3, 4, 3, 4, 2, 4, 5, 4,
        5, 1, 4, 3, 4, 6, 4, 3, 2, 3, 4, 3, 1, 3, 2,
        2, 4, 3, 5, 2, 4, 3, 4, 6, 4, 3, 4, 3, 4, 5,
        3, 2, 4, 1, 2, 3, 4, 3, 4, 6, 4, 2, 5, 6, 4,
        5, 4, 6, 4, 3, 4, 3, 2, 3, 4, 3, 4, 3, 4, 3,
        5, 3, 4, 3, 4, 1, 5, 3, 4, 3, 2, 5, 4, 3, 4,
        3, 4, 5, 4, 3, 4, 5, 4, 3, 4, 1, 4, 3, 1, 2,
        2, 6, 4, 3, 4, 2, 4, 3, 4, 5, 4, 3, 5, 3, 4,
        3, 4, 1, 4, 3, 4, 6, 4, 2, 4, 3, 6, 3, 2, 3
      ]
    end

    def self.score_card
      {
        18 => 0.5, 42 => 1.5, 38 => 0.5, 15 => 1.5, 19 => 0.5,  41 => 1.5,
        37 => 0.5, 14 => 1.5, 8  => 10,  20 => 0,   45 => 5,    36 => 0,
        13 => 5,   21 => 0,   46 => 8,   35 => 0,   22 => 0,    9  => 8,
        34 => 0,   48 => 10,  23 => 0,   10 => 5,   33 => 0,    47 => 8,
        11 => 5,   24 => 0,   44 => 5,   32 => 0,   12 => 5,    25 => 0,
        43 => 5,   31 => 0,   26 => 0,   40 => 0.5, 30 => 0,    17 => 0.5,
        27 => 0,   39 => 0.5, 28 => 0,   16 => 0.5, 29 => 'ADD'
      }
    end

    def self.total_marbles
      8
    end

    def self.starting_cost
      1
    end
  end

  class Round
    attr_reader :board, :marbles, :filled, :points

    def initialize
      @board   = Rules.board
      @marbles = Rules.total_marbles
      @filled  = []
      @points  = 0
    end

    def play!
      @marbles.times do
        @marbles -= 1
        # A point is "deleted" once a marble lands on it, since it cannot be
        # occupired agian in a single round.
        @board.delete_at(rand(@board.size)).tap do |landed_on|
          @filled << landed_on
          @points += landed_on
        end
      end

      Rules.score_card[@points] || 0
    end
  end

  class Game
    attr_reader :rounds, :rounds_played, :spent, :score, :prizes, :won

    def initialize
      @cost          = Rules.starting_cost
      @rounds        = []
      @rounds_played = 0
      @spent         = 0
      @score         = 0
      @prizes        = 1
      @won           = false
    end

    def play!(rounds = 100)
      rounds.times do
        @spent         += @cost
        @rounds_played += 1

        Round.new.tap do |round|
          @rounds << round
          score = round.play!

          if score == 'ADD'
            @cost   *= 2
            @prizes += 1
          else
            @score += score
            if won?
              @won = true
              # We won, so stop playing
              return true
            end
          end
        end
      end
      
      false
    end

    def won?
      @score >= 10
    end
  end
end
