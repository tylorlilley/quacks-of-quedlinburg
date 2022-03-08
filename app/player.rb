# frozen_string_literal: true

# Class to represent the various ingredients that are drawn from the bag
class Player

  PLAYER_BOARD_SPACES = [
    { victory_points: 0, coins: 0, ruby: false },
    { victory_points: 0, coins: 1, ruby: false },
    { victory_points: 0, coins: 2, ruby: false },
    { victory_points: 0, coins: 3, ruby: false },
    { victory_points: 0, coins: 4, ruby: false },
    { victory_points: 0, coins: 5, ruby: true },
    { victory_points: 1, coins: 6, ruby: false },
    { victory_points: 1, coins: 7, ruby: false },
    { victory_points: 1, coins: 8, ruby: false },
    { victory_points: 1, coins: 9, ruby: true },
    { victory_points: 2, coins: 10, ruby: false },
    { victory_points: 2, coins: 11, ruby: false },
    { victory_points: 2, coins: 12, ruby: false },
    { victory_points: 2, coins: 13, ruby: true },
    { victory_points: 3, coins: 14, ruby: false },
    { victory_points: 3, coins: 15, ruby: false },
    { victory_points: 3, coins: 15, ruby: true },
    { victory_points: 3, coins: 16, ruby: false },
    { victory_points: 4, coins: 16, ruby: false },
    { victory_points: 4, coins: 17, ruby: false },
    { victory_points: 4, coins: 17, ruby: true },
    { victory_points: 4, coins: 18, ruby: false },
    { victory_points: 5, coins: 18, ruby: false },
    { victory_points: 5, coins: 19, ruby: false },
    { victory_points: 5, coins: 19, ruby: true },
    { victory_points: 5, coins: 20, ruby: false },
    { victory_points: 6, coins: 20, ruby: false },
    { victory_points: 6, coins: 21, ruby: false },
    { victory_points: 6, coins: 21, ruby: true },
    { victory_points: 7, coins: 22, ruby: false },
    { victory_points: 7, coins: 22, ruby: true },
    { victory_points: 7, coins: 23, ruby: false },
    { victory_points: 8, coins: 23, ruby: false },
    { victory_points: 8, coins: 24, ruby: false },
    { victory_points: 8, coins: 24, ruby: true },
    { victory_points: 9, coins: 25, ruby: false },
    { victory_points: 9, coins: 25, ruby: true },
    { victory_points: 9, coins: 26, ruby: false },
    { victory_points: 10, coins: 26, ruby: false },
    { victory_points: 10, coins: 27, ruby: false },
    { victory_points: 10, coins: 27, ruby: true },
    { victory_points: 11, coins: 28, ruby: false },
    { victory_points: 11, coins: 28, ruby: true },
    { victory_points: 11, coins: 29, ruby: false },
    { victory_points: 12, coins: 29, ruby: false },
    { victory_points: 12, coins: 30, ruby: false },
    { victory_points: 12, coins: 30, ruby: true },
    { victory_points: 12, coins: 31, ruby: false },
    { victory_points: 13, coins: 31, ruby: false },
    { victory_points: 13, coins: 32, ruby: false },
    { victory_points: 13, coins: 32, ruby: true },
    { victory_points: 14, coins: 33, ruby: false },
    { victory_points: 14, coins: 33, ruby: true },
    { victory_points: 15, coins: 35, ruby: false }
  ].freeze

  SUPPORTED_TRAITS = %i[
    vocal
    buys_blue_chips
    buys_red_chips
    buys_yellow_chips
    buys_green_chips
    buys_purple_chips
    buys_black_chips
    buys_orange_chips
    refills_flask
    begins_buys_with_black_chip
    never_rolls_die
    buys_multiple_if_able
  ].freeze

  attr_accessor :traits, :risk_level, :game, :victory_points, :rubies, :droplet, :bag, :board,
                :distance, :flask

  def initialize(risk_level, traits = [])
    @risk_level = risk_level
    @traits = traits
  end

  def start_game(given_game)
    @game = given_game
    @bag = []
    @board = []
    @flask = true
    @rubies = 1
    @victory_points = 0
    @droplet = 0
    @distance = 0
    add_initial_chips
  end

  def add_chip(chip)
    vocalize "- Added #{chip} chip."
    bag << chip
  end

  def add_initial_chips
    add_chip(color: :orange, value: 1)
    add_chip(color: :green, value: 1)
    add_chip(color: :white, value: 1)
    add_chip(color: :white, value: 1)
    add_chip(color: :white, value: 1)
    add_chip(color: :white, value: 1)
    add_chip(color: :white, value: 2)
    add_chip(color: :white, value: 2)
    add_chip(color: :white, value: 3)
  end

  def begin_turn
    vocalize "\nBegining turn #{game.turn_number}..."
    reset_bag
    reset_distance
  end

  def stir
    vocalize 'Stirring...'
    use_flask_or_chip(draw_chip) until stop_drawing?
    if exploded?
      vocalize '-- Pot exploded; Stopped drawing.'
    elsif bag.empty?
      vocalize '-- Empty bag; Stopped drawing.'
    elsif at_edge_of_board?
      vocalize '-- Maxed out board; Stopped drawing.'
    else
      vocalize '-- Decided to stop drawing due to risk tolerance.'
    end
    distance
  end

  def draw_chip
    vocalize '- Drawing chip...'
    # vocalize_current_state
    chip = bag.delete_at(rand(bag.length))
    vocalize "-- Drawn chip is #{chip}."
    chip
  end

  def roll_bonus_die?(maximum_distance)
    return false if exploded? || traits.include?(:never_rolls_die)

    vocalize 'Checking for bonus die...'
    vocalize "- My distance traveled was #{distance}."
    vocalize "- Max distance traveled by a player was #{maximum_distance}."
    distance >= maximum_distance
  end

  def roll_bonus_die
    vocalize '- Rolling bonus die...'
    roll = rand(1..6)
    gain_victory_points(1) if [1, 2].include?(roll)
    gain_victory_points(2) if roll == 3
    gain_rubies(1) if roll == 4
    move_droplet(1) if roll == 5
    add_chip(color: :orange, value: 1) if roll == 6
  end

  def exploded?
    sum_of_white_chips > 7
  end

  def evaluation_phase_chip_action(color)
    game.ingredient_set.evaluation_phase_chip_action(self, color)
  end

  def potion_phase_chip_action(chip)
    add_distance chip[:value]
    game.ingredient_set.potion_phase_chip_action(self, chip)
    vocalize "-- Current distance is #{distance}, next_space is #{space_on_board}."
  end

  def space_on_board
    PLAYER_BOARD_SPACES[distance + 1]
  end

  def collect_ruby
    vocalize 'Checking for rubies...'
    gain_rubies(1) if space_on_board[:ruby]
  end

  def collect_victory_points
    # TODO: Decide better when to skip if exploded
    return if exploded? && game.turn_number < 9

    vocalize 'Checking for victory points...'
    gain_victory_points(space_on_board[:victory_points])
  end

  def buy_chips
    # TODO: Decide when to skip if exploded
    return if game.turn_number >= 9

    coins_to_spend = coins
    first_chip_color = nil
    (1..2).each do |_i|
      vocalize "Buying Chips with #{coins_to_spend}..."
      selection = available_purchase_options(coins_to_spend, first_chip_color).max_by { |_chip, cost| cost }
      # TODO: implement :buys_multiple_if_able trait
      unless selection.nil?
        coins_to_spend -= selection[1]
        first_chip_color = selection.first[:color]
        add_chip(selection.first)
      end
    end
  end

  def available_purchase_options(coins_to_spend, forbidden_color)
    game.ingredient_set.chip_costs.select do |chip, cost|
      next(vocalize "-- Chip #{chip} color not available") unless game.available_colors.include?(chip[:color])
      next(vocalize "-- Chip #{chip} color not interesting") unless player_color_interests.include?(chip[:color])
      next(vocalize "-- Chip #{chip} color already bought") if chip[:color] == forbidden_color
      next(vocalize "-- Chip #{chip} is too expensive at #{cost}") if cost > coins_to_spend
      true
    end
  end

  def spend_rubies
    vocalize "Spending #{rubies} rubies..."
    while rubies >= 2
      @rubies -= 2
      if !flask && traits.include?(:refills_flask)
        prepare_flask(true)
      else
        move_droplet(1)
      end
    end
  end

  def end_game
    vocalize "Ending game with #{coins} coins and #{rubies} rubies..."
    gain_victory_points(coins / 5) unless exploded?
    gain_victory_points(rubies / 2) if (rubies / 2) > 0
    vocalize "Ending game with #{victory_points} victory points."
    vocalize "Ending game with droplet at #{droplet}."
    reset_bag
    vocalize "Ending game with bag #{bag}."
    victory_points
  end

  def previous_chip
    board[-2]
  end

  def vocalize(string)
    puts string if traits.include?(:vocal)
  end

  def drawn_chips(color)
    board.select { |chip| chip[:color] == color }
  end

  def gain_victory_points(points)
    vocalize "- Gained #{points} victory points."
    @victory_points += points
  end

  def gain_rubies(rubies)
    vocalize "- Gained #{rubies} rubies."
    @rubies += rubies
  end

  def move_droplet(spaces)
    vocalize "- Moved droplet forward #{spaces} spaces."
    @droplet += spaces
  end

  def add_distance(spaces)
    vocalize "-- Moved current space forward #{spaces} spaces."
    @distance += spaces
    @distance = 52 if distance > 52
  end

  def prepare_flask(prepared)
    vocalize "- Set flask to #{prepared}."
    @flask = prepared
  end

  private

  def sum_of_white_chips
    drawn_chips(:white).reduce(0) { |sum, chip| sum + chip[:value] }
  end

  def owned_chips(color)
    board.count { |chip| chip[:color] == color } + bag.count { |chip| chip[:color] == color }
  end

  def use_flask_or_chip(chip)
    board << chip
    if flask && use_flask_on_chip?(chip)
      prepare_flask(false)
      add_chip board.pop
    else
      potion_phase_chip_action(chip)
    end
  end

  def vocalize_current_state
    vocalize "-- Current space on board is #{space_on_board} at distance #{distance}."
    vocalize "-- Current board is #{board}."
    vocalize "-- Current bag is #{bag}."
  end

  def stop_drawing?
    exploded? || bag.empty? || at_edge_of_board? || decided_to_stop?
  end

  def at_edge_of_board?
    space_on_board == PLAYER_BOARD_SPACES.last
  end

  def decided_to_stop?
    if traits.include?(:begins_buys_with_black_chip) && owned_chips(:black) == 0
      coins >= game.ingredient_set.chip_costs[{ color: :black, value: 1 }]
    else
      vocalize "-- Determing chance to explode with #{number_of_exploding_chips} / #{bag.length}."
      vocalize "-- Deciding whether to stop with risk level #{chance_to_explode} / #{risk_level}."
      chance_to_explode >= risk_level
    end
  end

  def chance_to_explode
    (number_of_exploding_chips.to_f / bag.length.to_f) * 100.00
  end

  def number_of_exploding_chips
    bag.count { |chip| exploding_chip?(chip) }
  end

  def exploding_chip?(chip)
    chip[:color] == :white && (chip[:value] + sum_of_white_chips) > 7
  end

  def player_color_interests
    {
      buys_orange_chips: :orange,
      buys_red_chips: :red,
      buys_blue_chips: :blue,
      buys_yellow_chips: :yellow,
      buys_green_chips: :green,
      buys_black_chips: :black,
      begins_buys_with_black_chip: (owned_chips(:black) > 0 ? nil : :black),
      buys_purple_chips: :purple
    }.select { |trait, _color| traits.include? trait }.values.uniq.compact
  end

  def use_flask_on_chip?(chip)
    return false if exploded?
    return false unless chip[:color] == :white

    chip_is_worth_using_flask?(chip) || previous_chip_is_worth_using_flask?(chip)
  end

  def chip_is_worth_using_flask?(chip)
    vocalize '-- Deciding whether to use flask on chip...'
    # TODO: Implement better logic for how to decide whether to use the flask
    (chip[:value] > 1 && sum_of_white_chips > 5) || (chip[:value] > 2 && board.length >= bag.length)
  end

  def previous_chip_is_worth_using_flask?(chip)
    return false unless traits.include? :buys_yellow_chips

    vocalize '-- Deciding whether to use flask on chip due to previous chip...'
    previous_chip[:color] == [:white] && previous_chip[:value] > 1
  end

  def coins
    space_on_board[:coins]
  end

  def reset_bag
    vocalize "- Bag reset."
    @bag << board.pop until board.empty?
  end

  def reset_distance
    vocalize "- Distance set to #{distance}."
    @distance = droplet
  end
end
