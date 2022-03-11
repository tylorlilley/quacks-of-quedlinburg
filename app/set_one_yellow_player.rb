# frozen_string_literal: true

# Class to represent the various ingredients that are drawn from the bag
class SetOneYellowPlayer < Player

  def initialize(risk_level, traits = [])
    super(risk_level, traits)
    @traits = traits + [:buys_yellow_chips]
  end

end
