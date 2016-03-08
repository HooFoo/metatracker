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
  field :images, type: String
  field :other, type: String

  elasticsearch!

  def self.by_query string, page
    string='' if string.nil?
    page=1 if page.nil?
    es.search(string,page: page,per_page: 15)
  end

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
