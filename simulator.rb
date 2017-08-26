require_relative 'razzle_dazzle'

class Simulator
  attr_reader :games, :sessions, :rounds, :average_spent, :average_rounds,
              :average_prizes, :average_rounds_to_win, :average_prizes_won

  def initialize(game_klass, sessions = 1000, rounds = 5000)
    @game_klass = game_klass
    @sessions = sessions
    @rounds = rounds
    @games = []
    @total_spent = 0.0
    @total_rounds = 0.0
    @total_prizes = 0.0
    @total_rounds_to_win = 0.0
    @total_prizes_won = 0.0
    @average_spent = 0.0
    @average_rounds = 0.0
    @average_prizes = 0.0
    @average_rounds_to_win = 0.0
    @average_prizes_won = 0.0
  end

  def play!
    @sessions.times do
      game = @game_klass.new
      game.play!(@rounds)
      @games << game

      @total_spent  += game.spent
      @total_rounds += game.rounds_played
      @total_prizes += game.prizes

      if game.won?
        @total_rounds_to_win += game.rounds_played
        @total_prizes_won += game.prizes
      end
    end

    @average_spent = @total_spent  / sessions
    @average_rounds = @total_rounds / sessions
    @average_prizes = @total_prizes / sessions
    @average_rounds_to_win = @total_rounds_to_win / sessions
    @average_prizes_won = @total_prizes_won / sessions
  end
end

game = RazzleDazzle::Game
sim  = Simulator.new(game)

puts "Playing #{sim.sessions} sessions of #{sim.rounds} rounds.."
sim.play!

puts "Won #{sim.games.select(&:won).count} games."
puts "Spent, on average, $#{"%f" % sim.average_spent} (#{sim.average_spent})."
puts "Took, on average, #{sim.average_rounds_to_win} rounds to win " +
     "#{sim.average_prizes_won} prizes."
