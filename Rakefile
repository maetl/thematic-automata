$LOAD_PATH << __dir__ + "/lib"

require "automaton"
require "rule"
require "markov"

EOL = "\n"

THEMES = {
  loneliness: ["lonely", "loneliness", "alone"],
  deception: ["deception", "deceipt", "fraud", "treachery", "cunning", "duplicity"],
  courage: ["courage", "strength", "valiant", "brave", "courageous", "strong"],
  love: ["love", "adulation", "adore", "adoration", "affection", "devotion", "passion"]
}

task :generate do
  sentences = File.read("corpus/tagged_sentences.txt").split(EOL)

  loneliness_sentences = sentences.select do |sentence|
    THEMES[:loneliness].any? do |thematic_word|
      sentence.downcase.include?(thematic_word)
    end
  end.shuffle

  love_sentences = sentences.select do |sentence|
    THEMES[:love].any? do |thematic_word|
      sentence.downcase.include?(thematic_word)
    end
  end.shuffle

  courage_sentences = sentences.select do |sentence|
    THEMES[:courage].any? do |thematic_word|
      sentence.downcase.include?(thematic_word)
    end
  end.shuffle

  deception_sentences = sentences.select do |sentence|
    THEMES[:deception].any? do |thematic_word|
      sentence.downcase.include?(thematic_word)
    end
  end.shuffle

  CHAINS = {
    "1" => Markov::Text.new(courage_sentences, splitter: :words),
    "0" => Markov::Text.new(deception_sentences, splitter: :words)
  }

  pattern = Automaton.new(rule: Rule.new, width: 60, generations: 30)
  chapters = []

  pattern.generate.each do |weave|
    paragraphs = []
    weave.chunk { |val| val }.each do |state, cells|
      paragraphs << cells.map { |c| CHAINS[state].generate }.join(" ").capitalize
    end
    chapters << paragraphs
  end

  result = chapters.reduce("") do |body, par|
    body << par.join("\n\n")
    body << "\n\n§\n\n"
  end

  puts result
end
