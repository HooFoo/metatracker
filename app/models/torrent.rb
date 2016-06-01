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

  elasticsearch! index_options: {
      settings: {
          index: {
              analysis: {
                  analyzer: {
                      app_analyzer: {
                          type: 'custom',
                          tokenizer: 'nGram',
                          filter: %w(stopwords app_ngram asciifolding lowercase snowball snowball_ru worddelimiter)},
                      app_search_analyzer: {
                          type: 'custom',
                          tokenizer: 'standard',
                          filter: %w(stopwords app_ngram asciifolding lowercase snowball snowball_ru worddelimiter)}
                  },
                  tokenizer: {
                      nGram: {
                          type: 'nGram',
                          min_gram: 2,
                          max_gram: 20}},
                  filter: {
                      snowball: {
                          type: 'snowball',
                          language: 'English'
                      },
                      snowball_ru: {
                          type: 'snowball',
                          language: 'Russian'
                      },
                      app_ngram: {
                          type: 'nGram',
                          min_gram: 4,
                          max_gram: 20
                      },
                      worddelimiter: {
                          type: 'word_delimiter'},
                      stopwords: {
                          type: 'stop',
                          stopwords: %w(хуй пизда ебать лох пидр пидар пидор чмо),
                          ignore_case: true}

                  }
              }
          }
      },
  },
                 index_mappings: {
                     title: {
                         type: 'multi_field',
                         fields: {
                             title: {type: 'string', analyzer: 'app_analyzer', boost: 1000},
                             suggest: {type: 'completion'}
                         }
                     },
                     description: {type: 'string', boost: 10},
                     category: {type: 'string', boost: 100}
                 }

  def self.by_query string, page
    string='' if string.nil?
    page=1 if page.nil?
    es.search({
                  q: Utils.clean(string),
                  analyzer: 'app_search_analyzer',
                  from: page*15,
                  size: 15
              }, page: page, per_page: 15)
      #es.search(string, page: page, per_page: 15, min_score: 4, analyzer: 'app_search_analyzer')
  end

  def self.autocomplete q
    es.completion(q, 'title.suggest').map { |e| e['text'] unless e.nil? }
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
