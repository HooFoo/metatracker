class Torrent
  include Mongoid::Document
  include Mongoid::Elasticsearch


  field :title, type: String
  field :description, type: String
  field :sub_category, type: String
  field :size, type: String
  field :href, type: String
  field :magnet, type: String
  field :seeds, type: Integer
  field :leech, type: Integer
  field :category, type: String
  field :images, type: String
  field :other, type: String

  elasticsearch! index_mappings: {
      title: {
          type: 'multi_field',
          fields: {
              title: {type: 'string', boost: 10},
              suggest: {type: 'completion'}
          }
      },
      description: {type: 'string'},
      category: {type: 'string'},
      other: {type: 'string'}
  }

  def self.by_query string, page
    string='' if string.nil?
    page=1 if page.nil?
    es.search(string,page: page,per_page: 15)
  end

  def self.autocomplete q
    es.completion(q,'title.suggest').map {|e| e['text'] unless e.nil? }
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
