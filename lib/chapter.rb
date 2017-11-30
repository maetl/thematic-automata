class Chapter
  def initialize(paragraphs, pattern)
    @paragraphs = paragraphs
    @pattern = pattern
  end

  def pattern
    @pattern.join("").gsub("0", '_').gsub("1", '•')
  end

  def paragraphs
    @paragraphs.join("\n\n")
  end
end
