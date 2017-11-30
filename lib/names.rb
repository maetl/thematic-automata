class Names
  def initialize(entity, count=8)
    @names = generate_names(entity, count)
  end

  def generate_names(entity, count)
    source = Markov::Text.new(File.read("corpus/#{entity.to_s}.txt").split("\n"), splitter: :chars)
    names = []

    count.times do
      names << source.generate
    end

    names
  end

  def names
    @names.shuffle
  end
end
