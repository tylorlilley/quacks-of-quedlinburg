# frozen_string_literal: true

require 'pry'
require 'enumerable/statistics'

require_relative 'game'
require_relative 'player'
require_relative 'set_one_red_player'
require_relative 'set_one_yellow_player'
require_relative 'ingredient_set'
require_relative 'ingredient_set_one'

# A class that represents a simulation of one or more games of quacks
class Simulation

  attr_accessor :players, :ingredient_set, :number_of_games, :outcomes

  def initialize(ingredient_set, players, number_of_games)
    @players = players
    @ingredient_set = ingredient_set
    @number_of_games = number_of_games
    @outcomes = []
  end

  def run
    outcomes << Game.new(ingredient_set, players).run while outcomes.length < number_of_games
    puts "\nSimulation Statistics"
    players.each_with_index { |_player, i| print_player_statistics(i) }
  end

  private

  def print_player_statistics(player_num)
    puts "\nStats for Player #{player_num}"
    games_won = games_won_by_player(player_num)
    puts "- Won #{games_won} out of #{number_of_games} games (#{percentage(games_won,
                                                                           number_of_games)} %)."
    puts "- Highest score among games was #{player_score_max(player_num)}."
    puts "- Lowest score among games was #{player_score_min(player_num)}."
    puts "- Average score among games was #{player_results(score_results, player_num).mean}."
    puts "- Variance of score values among games was #{player_results(score_results,
                                                                      player_num).variance}."
    puts "- Standard Deviation of score among games was #{player_results(score_results,
                                                                         player_num).stdev}."
  end

  def games_won_by_player(player_num)
    player_results(victory_results, player_num).count { |victory_result| victory_result }
  end

  def victory_results
    outcomes.map { |outcome| outcome[1] }
  end

  def player_score_max(player_num)
    player_results(score_results, player_num).max_by { |score_result| score_result }
  end

  def player_score_min(player_num)
    player_results(score_results, player_num).min_by { |score_result| score_result }
  end

  def score_results
    outcomes.map(&:first)
  end

  def player_results(results, player_num)
    results.map { |result| result[player_num] }
  end

  def percentage(part, total)
    (part.to_f / total) * 100.0
  end

end
