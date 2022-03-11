# frozen_string_literal: true

# A class that represents a single game playthrough of quacks
class Game

  RAT_TAIL_POSITIONS = [1.5, 4.5, 7.5, 10.5, 12.5, 14.5, 16.5, 18.5, 20.5, 22.5, 24.5, 26.5, 28.5,
                        30.5, 32.5, 34.5, 36.5, 38.5, 40.5, 42.5, 44.5, 46.5, 48.5, 51.5, 54.5,
                        57.5, 60.5, 62.5, 64.5, 66.5, 68.5, 70.5, 72.5, 74.5, 76.5, 78.5, 80.5,
                        82.5, 84.5, 86.5, 88.5, 90.5, 92.5, 94.5, 96.5, 98.5].freeze

  attr_accessor :turn_number, :available_colors, :players, :ingredient_set, :maximum_distance

  def initialize(ingredient_set, players)
    @turn_number = 0
    @available_colors = %i[red blue black green orange]
    @players = players
    @ingredient_set = ingredient_set
    initialize_players
  end

  def run
    play_round while turn_number < 9
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
    add_rats
  end

  def add_rats
    leading_player = players.max_by(&:victory_points)
    players.each { |player| player.add_rats(leading_player.victory_points) }
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
    [players.map(&:end_game), winners]
  end

  def winners
    max_score = players.max_by(&:victory_points).victory_points
    highest_scorers = players.select { |player| player.victory_points == max_score }
    max_tiebreaker_distance = highest_scorers.max_by(&:distance).distance
    tiebreaker_winners = highest_scorers.select { |player| player.distance == max_tiebreaker_distance }
    players.map { |player| tiebreaker_winners.include? player }
  end
end
