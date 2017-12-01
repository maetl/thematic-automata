require "socket"

class NERClient
  def initialize(sentences)
    @sentences = sentences
  end

  def map_entities
    @sentences.map { |sentence| process_sentence(sentence) }
  end

  def process_sentence(sentence)
    client = TCPSocket.open("localhost", 9090)
    client.puts(sentence)

    annotated_sentence = ""

    while line = client.gets
      annotated_sentence += line
    end

    client.close

    annotated_sentence
  end
end
