class Torrent
  include Mongoid::Document
  include Mongoid::Elasticsearch


  field :title, type: String
  field :description, type: String
  field :size, type: String
  field :href, type: String
  field :magnet, type: String
  field :seeds, type: Integer
  field :leech, type: Integer
  field :category, type: String
  field :images, type: Array

  elasticsearch!

  def self.generate_id obj
      obj[:title].hash & obj[:size].hash & obj[:href]
  end

  def == other
    if other.nil? or other.class!= self.class
       false
    else
      other.title.equal?(@title) && other.size.equal?(@size) && other.href.equal?(@href)
    end
  end
end
