class NamedEntities
  TAGS = {
    people: 'PERSON',
    locations: 'LOCATION',
    orgs: 'ORGANIZATION',
    misc: 'MISC'
  }

  attr_reader :people, :locations, :orgs, :misc

  def initialize
    @people = Names.new(:people)
    @locations = Names.new(:locations)
    @orgs = Names.new(:organizations)
    @misc = Names.new(:misc)
  end

  def populate(sentence)
    sentence = replace_entities(sentence, :people)
    sentence = replace_entities(sentence, :locations)
    sentence = replace_entities(sentence, :orgs)
    sentence = replace_entities(sentence, :misc)
    sentence
  end

  def replace_entities(sentence, entity)
    sentence.gsub(TAGS[entity]).each_with_index do |v, i|
      self.send(entity).names()[i]
    end
  end
end
