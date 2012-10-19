require 'sinatra'
require 'sunspot'
require 'rest-client'
require 'json'

before do
  WEBSOLR_URL = "http://127.0.0.1:8983/solr"
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
    speakers = format_facets(speaker_data)
    html << "Show only contributions by: #{speakers.join(" ")}"
  end
  
  html << "Showing blah to blah blah of #{result["response"]["numFound"]}"
  
  result["response"]["docs"].each do |search_result|
    id = search_result["id"]
    html << search_result["subject_ss"]
    html << search_result["url_ss"]
    html << search_result["speaker_name_ss"] if search_result["speaker_name_ss"]
    html << search_result["sitting_type_ss"]
    item_date = search_result["date_ds"]
    html << Date.parse(item_date).strftime("%B %d, %Y")
    html << result["highlighting"][id]["solr_text_texts"]
  end
  
  "<div>#{html.join("</div><div>")}</div>"
end

def format_facets(facet_array)
  output = []
  if facet_array.is_a?(Array)
    field_count = ""
    while facet_array.length > 0
      p 
      if field_count == ""
        field_count = "(#{facet_array.pop})"
      else
        output << "#{facet_array.pop} #{field_count}"
        field_count = ""
      end
    end
    output.reverse!
  end
  output
end