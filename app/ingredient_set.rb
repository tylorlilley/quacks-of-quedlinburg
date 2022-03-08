# frozen_string_literal: true

# Class to represent the various sets of ingredient costs and abilities
class IngredientSet

  def chip_costs
    {}
  end

  def chip_cost(chip)
    chip_costs[chip] || 0
  end

  def green_chip_action(player)
    # Do nothing by default
  end

  def black_chip_action(player)
    # Do nothing by default
  end

  def purple_chip_action(player)
    # Do nothing by default
  end

  def red_chip_action(player, chip)
    # Do nothing by default
  end

  def blue_chip_action(player, chip)
    # Do nothing by default
  end

  def yellow_chip_action(player, chip)
    # Do nothing by default
  end

  def evaluation_phase_chip_action(player, color)
    case color
    when :green
      green_chip_action(player)
    when :black
      black_chip_action(player)
    when :purple
      purple_chip_action(player)
    end
  end

  def potion_phase_chip_action(player, chip)
    case chip[:color]
    when :red
      red_chip_action(player, chip)
    when :blue
      blue_chip_action(player, chip)
    when :yellow
      yellow_chip_action(player, chip)
    end
  end

end
