require "set"
require "tools/ner_client"

EOL = "\n"

module Tools
  class CleanCorpus
    def self.strip_sections
      sentences = File.read("data/sentences.txt").split(EOL).map do |sentence|
        sentence.gsub('* * * * * ', '')
                .gsub(/,([A-Za-z])/, ", \\1")
                .gsub(/,([A-Za-z])/, ", \\1")
      end.reject do |sentence|
        sentence == "."
      end.reject do |sentence|
        /^[A-Z0-9\s\.]+$/.match(sentence)
      end

      File.write("data/sentences.txt", sentences.join(EOL))
    end
    end

    def self.strip_punctuation
      sentences = File.read("data/sentences.txt").split(EOL).map do |sentence|
        sentence.gsub('" ', '')
                .gsub('"', '')
                .gsub('--', '—')
                .gsub('_', '—')
                .gsub('. . .', '...')
                .gsub('[Illustration]', '')
      end

      File.write("data/sentences.txt", sentences.join(EOL))
    end

    def self.recognize_entities
      sentences = File.read("corpus/sentences.txt").split(EOL)
      ner_client = NERClient.new(sentences)
      entities = ner_client.map_entities
      File.write("data/ner_tagged_sentences.txt", entities.join(EOL))
    end

    def self.extract_entities(sentence, entity)
      tag = entity.to_s.upcase
      sentence.scan(/<#{tag}>([^<]*)<\/#{tag}>/).map { |match| match[0] }
    end

    def self.replace_entity_tags(sentence, entity)
      tag = entity.to_s.upcase
      sentence.gsub(/<#{tag}>([^<]*)<\/#{tag}>/, "#{tag}")
    end

    def self.normalize_entities
      sentences = File.read("data/ner_tagged_sentences.txt").split(EOL)

      tagged = sentences.map do |sentence|
        result = replace_entity_tags(sentence, :person)
        result = replace_entity_tags(result, :location)
        result = replace_entity_tags(result, :organization)
        result = replace_entity_tags(result, :misc)
        result
      end

      File.write("data/tagged_sentences.txt", tagged.join(EOL))
    end

    def self.extract_entities
      people = Set.new
      locations = Set.new
      organizations = Set.new
      misc = Set.new

      sentences = File.read("data/ner_tagged_sentences.txt").split(EOL)

      sentences.each do |sentence|
        extracted_people = extract_entities(sentence, :person)
        people.merge(extracted_people) unless extracted_people.empty?

        extracted_locations = extract_entities(sentence, :location)
        locations.merge(extracted_locations) unless extracted_locations.empty?

        extracted_misc = extract_entities(sentence, :misc)
        misc.merge(extracted_misc) unless extracted_misc.empty?

        extracted_organizations = extract_entities(sentence, :organization)
        organizations.merge(extracted_organizations) unless extracted_organizations.empty?
      end

      File.write("data/people.txt", people.to_a.join(EOL))
      File.write("data/locations.txt", locations.to_a.join(EOL))
      File.write("data/organizations.txt", organizations.to_a.join(EOL))
      File.write("data/misc.txt", misc.to_a.join(EOL))
    end
  end
end
