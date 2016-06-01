class Query
  include Mongoid::Document
  include Mongoid::Elasticsearch

  field :str, type: String
  field :weight, type: Integer, default: 1

  elasticsearch! index_options: {
      settings: {
          index: {
              analysis: {
                  analyzer: {
                      query_analyzer: {
                          type: 'custom',
                          tokenizer: 'nGram',
                          filter: %w(stopwords)},
                  },
                  filter: {
                      stopwords: {
                          type: 'stop',
                          stopwords: %w(хуй хуя хуе хуё пизда пизде пизду пезд пёзд ебать ебля ебырь лох пидр пидар пидор чмо),
                          ignore_case: true
                      }
                  }
              }
          }
      },
  },
                 index_mappings: {
                     str: {
                         type: 'multi_field',
                         fields: {
                             suggest: {type: 'completion',  analyzer: 'query_analyzer'}
                         }
                     }
                 }


  def self.create q
    existing = where(:str => q).first
    if existing.present?
      existing.weight+=1
    else
      existing = Query.new(:str => q)
    end
    existing.save
    existing
  end

  def self.autocomplete q
    es.completion(q, 'str.suggest').sort { |x,y| x.weight <=> y.weight }.map { |e|
      e['text'] unless e.nil?
    }
  end

end
