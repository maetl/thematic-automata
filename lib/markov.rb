module Markov
  class Text
    EOL = "\n".freeze
    EMPTY = ''.freeze
    SPACE = ' '.freeze
    DEFAULT_DEPTH = 2

    def self.load(file, options = {})
      self.build(File.read(file), options)
    end

    def self.build(text, options = {})
      self.new(text.split(EOL), options)
    end

    def initialize(lines, options)
      @depth = options[:depth] || DEFAULT_DEPTH
      @splitter = splitter_format(options[:splitter])
      @starting = []
      @ending = []
      @index = {}

      build_index(lines)
    end

    def generate
      begin
        current_val = @starting.sample
        next_val = @index[current_val].sample
      rescue
        # TODO: better handling of this
        current_val = @starting.sample
        next_val = @index[current_val].sample
      end

      return current_val if next_val.nil?

      seq = [current_val.split(@splitter)[0..1]]

      until next_val.nil?
        current_val = next_val
        seq << current_val.split(@splitter)[1..-1]
        next_val = @index[current_val].sample
      end

      seq.join(@splitter)
    end

    private

    def splitter_format(option)
      case option
      when :words then SPACE
      when :chars then EMPTY
      else
        SPACE
      end
    end

    def build_index(lines)
      lines.each do |line|
        atoms = split_ngrams(line, @depth)

        @starting << atoms.first
        @ending << atoms.last

        atoms.each_with_index do |seq, i|
          unless @index.key?(seq)
            @index[seq] = []
          end

          if is_indexable?(seq)
            @index[seq] << atoms[i+1]
          end
        end
      end

      @starting.select! { |v| !v.nil? }
    end

    def is_indexable?(seq)
      !@ending.include?(seq) || @starting.include?(seq)
    end

    def split_ngrams(text, depth)
      atoms = []
      text.split(@splitter).each_cons(depth) do |seq|
        atoms << seq.join(@splitter)
      end
      atoms
    end
  end
end
