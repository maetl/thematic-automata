class Book
  WORD_COUNT = 50_000

  def initialize(output_path: "output")
    @output_path = output_path
    @timestamp = Time.new.to_i
    @rule = Rule.new
    @swatch = Swatch.new
    @theme = Theme.new
  end

  def generate_rule_image
    image = RuleImage.new(automaton(200, 200).generate, @swatch.light, @swatch.dark, 200, 200)
    image.save("#{@output_path}/rule-#{@timestamp}.png")
  end

  def generate_cover_image
    image = RuleImage.new(automaton(210, 297).generate, @swatch.light, @swatch.dark, 210, 297)
    image.save("#{@output_path}/cover-#{@timestamp}.png")
  end

  def generate_document
    literary_spew = LiterarySpew.new(@theme, automaton(60, 34))
    document = Document.new(@rule, @theme, literary_spew, @swatch, @timestamp)
    document.render_sections
    document.save_as("#{@output_path}/book-#{@timestamp}.pdf")
  end

  def generate
    generate_cover_image
    generate_rule_image
    generate_document
  end

  def automaton(width, generations)
    Automaton.new(rule: @rule, width: width, generations: generations)
  end
end
