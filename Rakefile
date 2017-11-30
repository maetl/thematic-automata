$LOAD_PATH << __dir__ + "/lib"

require "thematic_automata"

task :generate do
  pattern = Automaton.new(rule: Rule.new, width: 60, generations: 30)
  chapters = []

  entities = NamedEntities.new
  sentences = Sentences.new(Theme.new)

  pattern.generate.each do |weave|
    paragraphs = []
    weave.chunk { |val| val }.each do |state, cells|
      paragraphs << cells.map do |c|
        entities.populate(sentences.generate_for(state))
      end.join(" ")
    end
    chapters << paragraphs
  end

  result = chapters.reduce("") do |body, par|
    body << par.join("\n\n")
    body << "\n\n§\n\n"
  end

  puts result
end
