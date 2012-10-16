require 'sunspot'

class Indexer
  def initialize
    Sunspot.config.solr.url = "http://127.0.0.1:8983/solr"
  end
  
  def add_document(contribution)  
    Sunspot.index(contribution)
    Sunspot.commit
  end
end