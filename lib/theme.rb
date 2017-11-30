require "calyx"

class Theme
  SYNONYMS = {
    loneliness: ["lonely", "loneliness", "alone", "despair", "isolation", "isolated", "heartache", "desolate", "desolation", "forlorn", "solitude"],
    deception: ["deception", "deceipt", "fraud", "treachery", "cunning", "duplicity", "betrayal", "cheat", "cheating", "mendacious", "mendacity"],
    courage: ["courage", "strength", "valiant", "brave", "courageous", "courageously", "strong"],
    love: ["love", "adulation", "adore", "lovely", "lover", "adoring", "adoration", "affection", "devotion", "passion"]
  }

  attr_reader :figure, :ground

  def initialize
    @figure, @ground = SYNONYMS.keys.sample(2)
  end

  def synonyms(key)
    SYNONYMS[key]
  end

  def title
    Calyx::Grammar.new do
      start :and_phrase, :concat_phrase, :against_phrase, :or_phrase
      and_phrase "{figure} and {ground}", "{figure} & {ground}"
      concat_phrase "{figure} {ground}"
      against_phrase "{figure} Against {ground}"
      or_phrase "{figure} or {ground}"
    end.generate(figure: @figure.to_s.capitalize, ground: @ground.to_s.capitalize)
  end
end
