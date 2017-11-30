class LiterarySpew
  def initialize(theme, automaton)
    @entities = NamedEntities.new
    @sentences = Sentences.new(theme)
    @automaton = automaton
  end

  def generate
    chapters = []

    @automaton.generate.each do |weave|
      paragraphs = []
      weave.chunk { |val| val }.each do |state, cells|
        paragraphs << cells.map do |c|
          @entities.populate(@sentences.generate_for(state))
        end.join(" ")
      end
      chapters << Chapter.new(paragraphs, weave)
    end

    chapters
  end
end
