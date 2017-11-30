class Swatch
  SPOT_COLORS = [
    "0A8754",
    "508CA4",
    "7E78D2",
    "6F58C9",
    "CFD11A",
    "C46D5E",
    "7B8CDE",
    "D5A021",
    "A04D96",
    "679436",
    "05668D"
  ]

  attr_reader :light, :dark

  def initialize
    @light = SPOT_COLORS.sample
    @dark = "222222"
  end
end
