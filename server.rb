require 'sinatra'
require 'sunspot'
require 'rest-client'
require 'json'
require 'haml'

require 'active_record'
require './models/person'
require './models/search_result'

before do
  WEBSOLR_URL = "http://127.0.0.1:8983/solr"
  
  dbconfig = YAML::load(File.open 'config/database.yml')[ Sinatra::Application.environment.to_s ]
  ActiveRecord::Base.establish_connection(dbconfig)
end

get "/" do
  query = "the"
  url = WEBSOLR_URL + "/select/?q=solr_text_texts:#{CGI::escape(query)}&facet=true&facet.field=decade_is&facet.field=year_is&facet.field=sitting_type_ss&facet.field=speaker_url_ss&wt=json&hl.fragsize=150&hl=true&hl.fl=solr_text_texts&facet.zeros=false"
  #&sort=date_ds+desc
  #&fq=speaker_name_ss:%22Mr%20Isaac%20Corry%22
  #&facet.query=decade_is:1800
  
  response = RestClient.get(url)
  result = JSON.parse(response)
  
  html = []
  
  p result["facet_counts"]["facet_fields"].inspect
  
  speaker_data = result["facet_counts"]["facet_fields"]["speaker_url_ss"]
  if speaker_data.is_a?(Array)
    speakers = facets_to_hash(speaker_data)
    speaker_list = []
    speakers.each do |name, count|
      speaker_list << "#{format_name(name)} (#{count})"
    end
    html << "Show only contributions by: #{speaker_list.join(" ")}"
  end
  
  html << "Showing blah to blah blah of #{result["response"]["numFound"]}"
  
  result["response"]["docs"].each do |search_result|
    id = search_result["id"]
    result_line = SearchResult.new(search_result["subject_ss"], search_result["url_ss"], search_result["speaker_name_ss"], search_result["speaker_url_ss"], search_result["sitting_type_ss"], search_result["date_ds"], result["highlighting"][id]["solr_text_texts"].join(" "))
    html << haml(:"_result", :locals => {:result => result_line}, :layout => false)
  end
  
  "<html><head><style>blockquote{margin:1em 0;} .search-result-fragment{padding-bottom:1em;} .search-result blockquote{margin:0;} .search-result h4{font-style:normal;font-weight:normal;margin:0;display:inline;margin-right:0.2em;} .search-result-fragment em{font-style:normal;background-color:yellow;} .search-result .date{display:inline;color:green;font-size:85%;} .search-result cite{}</style><body><div>#{html.join("</div><div>")}</div></body></html>"
end

def facets_to_hash(facet_array)
  output = {}
  if facet_array.is_a?(Array)
    field_count = ""
    while facet_array.length > 0
      if field_count == ""
        field_count = facet_array.pop.to_i
      else
        output[facet_array.pop] = field_count
        field_count = ""
      end
    end
  end
  output.sort_by{ |name, count| count }.reverse
end

def format_name(url)
  slug = url.split("/").pop
  person = Person.find_by_slug(slug)
  person.name
end