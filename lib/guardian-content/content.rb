class GuardianContent::Content < GuardianContent::Base

  attr_reader :title, :id, :url, :publication_date, :section_id, :body, :keywords, :fields, :headline, :tags, :attributes

  def initialize(attributes = {})
    @attributes = attributes
    @id = attributes[:id]
    @title = attributes[:webTitle]
    @url = attributes[:webUrl]
    @section_id = attributes[:sectionId]
    @publication_date = DateTime.parse(attributes[:webPublicationDate]) if attributes && attributes[:webPublicationDate]
    @body = attributes[:body]
    
    if attributes[:tags]
      @tags = []
      attributes[:tags].each do |tag|
        @tags << tag
      end
    end
    
    @fields = attributes[:fields].nested_symbolize_keys! if attributes[:fields]
    
    if attributes[:fields]
      @headline = attributes[:fields][:headline]
    end
  end

  def inspect
    "#<Article id: \"" + self.id.to_s + "\" title: \"" + self.title.to_s + "\" + url: \"" + self.url.to_s + "\">"
  end
  
  def section
    return GuardianContent::Section.find_by_id(self.section_id)
  end

  # Does a text search for content, with various options.
  # === Parameters
  # * <tt>:conditions</tt> - A hash which can accept <tt>:tag</tt>, <tt>:section</tt>, <tt>:from</tt> and <tt>:to</tt>, eg: <code>:conditions => {:tag => "poltiics/gordon-brown", :from => Date.yesterday}</code>
  # * <tt>:limit</tt> - An integer determining the maximum number of results to return (max: 50).
  # * <tt>:order</tt> - The order of the results. Can be <tt>:relevance</tt>, <tt>:oldest</tt> or <tt>:newest</tt>
  # === Examples
  #   * GuardianContent::Content.search("election")
  #   * GuardianContent::Content.search("election", :conditions => {:section => "politics"})
  def self.search(q, options = {})
    
    query = {}
    query["page-size"] = options[:limit] if options[:limit]
    query["order-by"] = options[:order] if options[:order]

    if options[:select]
      if options[:select][:tags]
        query["show-tags"] = options[:select][:tags]
      end
      if options[:select][:fields]
        query["show-fields"] = options[:select][:fields]
      end
    end

    if options[:conditions]
      conditions = options[:conditions]
      
      query[:tag] = conditions[:tag] if conditions[:tag]
      query[:section] = conditions[:section] if conditions[:section]

      query["from-date"] = Date.parse(conditions[:from]).to_s if conditions[:from]
      query["to-date"] = Date.parse(conditions[:to]).to_s if conditions[:to]

    end

    
    query[:format] = "json"
      
    query[:q] = q
    
    opts = {:query => query}

    response = self.get("/search", opts).nested_symbolize_keys![:response]
    
    results = recursively_symbolize_keys!(response[:results])
    content = []

    results.each do |result|
      content << GuardianContent::Content.new(recursively_symbolize_keys!(result))
    end
    return content
  end

  # Fetch a Content item using its id. IDs are usually in the form of <tt>section/YYYY/month/DD/name-of-article</tt>. 
  def self.find_by_id(id, options = {})
    
    query = {}
    query["show-fields"] = "all"
    query["show-tags"] = "all"
    query[:format] = "json"
    opts = {:query => query}
        
    attributes = {}
    
    response = recursively_symbolize_keys!self.get("/#{id}", opts).nested_symbolize_keys![:response]
    
    content = response[:content]

    return GuardianContent::Content.new(recursively_symbolize_keys!(content))
    
  end  
  
end
