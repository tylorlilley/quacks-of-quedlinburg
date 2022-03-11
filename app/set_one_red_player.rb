# frozen_string_literal: true

# Class to represent the various ingredients that are drawn from the bag
class SetOneRedPlayer < Player

  def initialize(risk_level, traits = [])
    super(risk_level, traits)
    @traits = traits + %i[buys_red_chips buys_orange_chips buys_multiple_if_able]
  end

  def use_flask_on_chip?(chip)
    return false if exploded?
    return false unless chip[:color] == :white

    chip_is_worth_using_flask?(chip) || previous_chip_is_worth_using_flask?(chip)
  end

  def previous_chip_is_worth_using_flask?(_chip)
    return false unless traits.include? :buys_yellow_chips

    vocalize '-- Deciding whether to use flask on chip due to previous chip...'
    previous_chip[:color] == [:white] && previous_chip[:value] > 1
  end

end
