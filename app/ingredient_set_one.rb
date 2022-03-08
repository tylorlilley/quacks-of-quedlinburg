# frozen_string_literal: true

# Class to represent the first set of ingredient costs and abilities
class IngredientSetOne < IngredientSet

  CHIP_COSTS = {
    { color: :orange, value: 1 } => 3,
    { color: :black, value: 1 } => 10,
    { color: :purple, value: 1 } => 9,
    { color: :red, value: 1 } => 6,
    { color: :red, value: 2 } => 10,
    { color: :red, value: 4 } => 16,
    { color: :blue, value: 1 } => 5,
    { color: :blue, value: 2 } => 10,
    { color: :blue, value: 4 } => 19,
    { color: :green, value: 1 } => 4,
    { color: :green, value: 2 } => 8,
    { color: :green, value: 4 } => 14,
    { color: :yellow, value: 1 } => 8,
    { color: :yellow, value: 2 } => 12,
    { color: :yellow, value: 4 } => 18
  }.freeze

  def chip_costs
    CHIP_COSTS
  end

  def green_chip_action(player)
    # TODO: Implement
  end

  def black_chip_action(player)
    # TODO: Implement
  end

  def purple_chip_action(player)
    # TODO: Implement
  end

  def red_chip_action(player, _chip)
    # Extra distance when drawn after other orange chips
    drawn_orange_chips = player.drawn_chips(:orange).length
    player.vocalize "-- Determining red chip action for #{drawn_orange_chips} orange chips"
    player.add_distance(1) if drawn_orange_chips.positive?
    player.add_distance(1) if drawn_orange_chips > 2
  end

  def blue_chip_action(player, chip)
    # Draw a number of chips and optionally place the best one
    optional_chips = []
    (1..chip[:value]).each { |_i| optional_chips << player.draw_chip }
    selected_chip = optional_chips.delete(select_optional_chip(optional_chips))
    player.potion_phase_chip_action(selected_chip) if selected_chip.present?
    player.add_chip(optional_chips.pop) until optional_chips.empty?
  end

  def yellow_chip_action(player, _chip)
    # Return the previous chip to the bag if it was white
    player.add_chip(player.board.delete_at(-2)) if player.previous_chip[:color] == :white
  end

  private

  def select_optional_chip(optional_chips)
    chosen_chips = optional_chips.compact.select do |chip|
      chip[:color] != :white &&
        chip[:color] != :yellow &&
        (chip[:color] != :red || player.drawn_chips(:orange).count > 2)
    end

    chosen_chips.sort_by! { |chip| optional_chip_score(chip) }
    chosen_chips.first
  end

  def optional_chip_score(chip)
    chip_cost(chip) + (chip[:color] == :blue ? 100 : 0)
  end

end
