class GuardianContent::Tag < GuardianContent::Base

  attr_reader :title, :id, :url, :type, :section_id, :section_name
  
  def initialize(attributes = {})
    @id = attributes[:id] || nil
    @title = attributes[:webTitle] || nil
    @url = attributes[:webUrl] || nil
    @type = attributes[:type] || nil
    @section_id = attributes[:sectionId] || nil
    @section_name = attributes[:sectionName] || nil    
  end

  def inspect
    "#<Tag id: \"" + self.id + "\" type: \"" + self.type + "\" title: \"" + self.title.to_s + "\" url: \"" + self.url.to_s + "\">"
  end  
  
  
  # Performs a text search for a tag.
  # === Parameters
  # * <tt>:conditions</tt> - 
  def self.search(q, options = {})

    query = {}
  
    query[:q] = q
    query[:format] = "json"

    query["page-size"] = options[:limit] if options[:limit]    
    opts = {:query => query}
    
    if options[:conditions]
      conditions = options[:conditions]
      query[:type] = conditions[:type] if conditions[:type]
      query[:section] = conditions[:section] if conditions[:section]
    end    
  
    response = self.get("/tags", opts).nested_symbolize_keys![:response]
    
    results = recursively_symbolize_keys!(response[:results])
    content = []

    results.each do |result|
      content << GuardianContent::Tag.new(recursively_symbolize_keys!(result))
    end
    return content  
  end
  
  
  # Returns the section associated with a Tag.
  def section
    return GuardianContent::Section.new(:id => self.section_id, :webTitle => self.section_name, :webUrl => "http://www.guardian.co.uk/" + self.section_id)
  end  
  
  
  # Retrieve a tag based upon its ID. Ids generally take the form of <tt>section/tag-name</tt>.
  # === Examples
  # * <tt>GuardianContent::Tag.find_by_id("politics/gordon-brown")</tt>
  # * <tt>GuardianContent::Tag.find_by_id("environment/nuclearpower")</tt>
  def self.find_by_id(id)
    
    query = {}
    query["show-fields"] = "all"
    query["show-tags"] = "all"
    query[:format] = "json"
    opts = {:query => query}
    
    return self.get("/#{id}").nested_symbolize_keys![:response][:tag]
  
  end  
  
end