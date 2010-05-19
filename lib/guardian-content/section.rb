class GuardianContent::Section < GuardianContent::Base

  attr_reader :title, :id, :url
  
  def initialize(attributes = {})
    @@attributes = attributes
    @id = attributes[:id] || nil
    @title = attributes[:webTitle] || nil
    @url = attributes[:webUrl] || nil
  end

  def inspect
    "#<Section id: \"" + self.id.to_s + "\" title: \"" + self.title.to_s + "\" url:\"" + self.url + "\">"
  end  

  def self.search(q, options = {})

    query = {}
  
    query[:q] = q
    query[:format] = "json"
    opts = {:query => query}    

    response = self.get("/sections", opts).nested_symbolize_keys![:response]
    
    results = recursively_symbolize_keys!(response[:results])
    content = []

    results.each do |result|
      content << GuardianContent::Section.new(recursively_symbolize_keys!(result))
    end
    return content  
  end
  
  def self.find_by_id(id)

    query = {}
    query["show-fields"] = "all"
    query[:format] = "json"
    opts = {:query => query}    
    
    response = recursively_symbolize_keys!self.get("/#{id}", opts).nested_symbolize_keys![:response]
    
    content = response[:section]

    return GuardianContent::Section.new(recursively_symbolize_keys!(content))
  end  
  
  def content(options = {})
    GuardianContent::Content.search("", options.merge!(:conditions => {:section => self.id}))
  end
  
  def self.all(options = {})

    response = self.get("/sections", {:query => {:format => "json"}}).nested_symbolize_keys![:response]
    
    results = recursively_symbolize_keys!(response[:results])
    content = []

    results.each do |result|
      content << GuardianContent::Section.new(recursively_symbolize_keys!(result))
    end
    return content    
  end
  
end