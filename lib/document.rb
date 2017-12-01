require "prawn"

class Document
  include Prawn::View

  def initialize(rule, theme, literary_spew, swatch, timestamp)
    @rule_id = rule.id
    @theme = theme
    @chapters = literary_spew.generate
    @swatch = swatch
    @timestamp = timestamp
    @document = Prawn::Document.new(page_size: "A4")
    font_families.update(
      "PT Serif" => {
        normal: "fonts/PTF55F.ttf",
        bold: "fonts/PTF75F.ttf"
      }
    )
  end

  def render_appendix
    start_new_page(margin: 90)

    font("PT Serif") do
      move_down 290
      font_size(18) { text("Appendix") }
      move_down 12
      text(File.read("./content/appendix.txt"))
    end
  end

  def render_colophon
    start_new_page(margin: 90)

    font("PT Serif") do
      move_down 384
      font_size(18) { text("Colophon") }
      move_down 12
      text(File.read("./content/colophon.txt"))
    end
  end


  def render_preface
    start_new_page(margin: 72)

    font("PT Serif") do
      move_down 384
      font_size(18) { text("Preface") }
      move_down 12
      text(File.read("./content/preface.txt"))
    end
  end

  def render_copyright
    start_new_page(margin: 90)

    font("PT Serif") do
      move_down 384
      text(File.read("./content/copyright.txt"), align: :center)
    end
  end

  def render_half_title
    start_new_page

    font("PT Serif") do
      move_down 128
      font_size(18) { text("Thematic Automata", align: :center) }
    end
  end

  def render_title
    start_new_page

    font("PT Serif", style: :bold) do
      move_down 128
      font_size(36) { text("Thematic Automata", align: :center) }
      move_down 18
      font_size(18) { text("By Mark Rickerby", align: :center) }
    end
  end

  def render_body
    font("PT Serif") do
      @chapters.each_with_index do |chapter, i|
        start_new_page(margin: 72)
        text(chapter.pattern + "\n\nChapter #{i+1}", align: :center)
        move_down 260
        text(chapter.paragraphs, color: @swatch.dark)
      end
    end
  end

  def render_contents
    start_new_page

    font("PT Serif") do
      move_down 128
      font_size(36) { text(@theme.title, align: :center) }
      move_down 18
      font_size(18) { text("Rule #{@rule_id}", align: :center) }
    end

    move_down 36
    image("output/rule-#{@timestamp}.png", position: :center)
  end

  def render_cover
    canvas do
      float do
        transparent(0.2) do
          image("output/cover-#{@timestamp}.png", position: :center, vposition: :center, scale: 2.834)
        end
      end

      font("PT Serif", style: :bold) do
        fill_color "222222"
        move_down 330
        font_size(90) { text(@theme.title, align: :center) }
      end
    end
  end

  def render_sections
    render_cover
    render_half_title
    render_title
    render_copyright
    render_preface
    start_new_page
    render_contents
    render_body
    start_new_page
    render_appendix
    render_colophon
  end
end
