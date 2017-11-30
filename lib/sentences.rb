class Sentences
  EOL = "\n"

  def initialize(theme)
    @theme = theme
    @sentences = File.read("data/tagged_sentences.txt").split(EOL)
    @figure_source = construct_source(@theme.figure)
    @ground_source = construct_source(@theme.ground)
  end

  def construct_source(theme)
    Markov::Text.new(prune_sentences(theme), splitter: :words)
  end

  def prune_sentences(theme)
    @sentences.select do |sentence|
      @theme.synonyms(theme).any? do |thematic_word|
        sentence.downcase.include?(thematic_word)
      end
    end.shuffle
  end

  def generate_for(bit)
    case bit.to_i
    when 0 then @figure_source.generate
    when 1 then @ground_source.generate
    end
  end
end
