# frozen_string_literal: true

require_relative 'player'
require_relative 'ingredient_set'
require_relative 'ingredient_set_one'

# A class that represents a single game playthrough of quacks
class Game

  attr_accessor :turn_number, :available_colors, :players, :ingredient_set, :maximum_distance

  def initialize(ingredient_set, players)
    @turn_number = 0
    @available_colors = %i[red blue black green orange]
    @players = players
    @ingredient_set = ingredient_set
    initialize_players
  end

  def run
    play_round while (turn_number < 9)
    end_game
  end

  private

  def initialize_players
    players.each { |player| player.start_game(self) }
    # TODO: assign players seats so that they know which player is to their left and to their right
  end

  def play_round
    begin_turn
    potions_phase
    evaluation_phase
  end

  def begin_turn
    @maximum_distance = 1
    @turn_number += 1
    players.each(&:begin_turn)
    available_colors << :yellow if turn_number == 2
    available_colors << :purple if turn_number == 3
    players.each { |player| player.add_chip(color: :white, value: 1) } if turn_number == 6
    # TODO: Draw Fortune Teller Card
    # TODO: Apply Rats
  end

  def potions_phase
    @maximum_distance = players.map(&:stir).max
  end

  def evaluation_phase
    bonus_die
    chip_actions :black
    chip_actions :green
    chip_actions :purple
    rubies
    victory_points
    buy_chips
    end_of_turn
  end

  # Step A - Players tied for greatest distance roll the die
  def bonus_die
    players.each { |player| player.roll_bonus_die if player.roll_bonus_die?(maximum_distance) }
  end

  # Step B - Players activate green, black, and purple abilities
  def chip_actions(color)
    players.each { |player| player.evaluation_phase_chip_action(color) }
  end

  # Step C - Players collect rubies based on thier distance traveled
  def rubies
    players.each(&:collect_ruby)
  end

  # Step D - Players collect victory points based on thier distance traveled
  def victory_points
    players.each(&:collect_victory_points)
  end

  # Step E - Players buy up to two chips of different colors using the coins they earned
  def buy_chips
    players.each(&:buy_chips) if turn_number < 9
  end

  # Step F - Players may spend rubies to move their droplet forward or fill up the flask
  def end_of_turn
    players.each(&:spend_rubies) if turn_number < 9
  end

  def end_game
    players.map(&:end_game)
  end

end
