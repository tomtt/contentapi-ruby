# This class represents 'content' items that have appeared on guardian.co.uk.  Content items
# are usually articles, but can also be image galleries, videos, and so on.
# ==== Attributes
# * +id+ - The Guardian ID of the content item, which is the same as the 'path' part of its URL, eg +world/2010/may/17/iran-nuclear-uranium-swap-turkey+
# * +title+ - The content item's title, as used on its web page.
# * +url+ - The full URL of the content item.
# * +publication_date+ - The date and time on which the content item was published. Returned as a DateTime instance.
# * +tags+ - A hash containing all of the content item's 'tags' (see Tag). Note, these are only available if selected, eg <code>find_by_id(id, :select => {:tags => :all})</code>
# * +fields+ - A hash containing all of the content item's 'fields'. Note, these are only available if selected - eg <code>find_by_id(id, :select => {:fields => :all})</code>
class GuardianContent::Content < GuardianContent::Base

  attr_reader :title, :id, :url, :publication_date, :section_id, :body, :keywords, :fields, :headline, :tags, :attributes

  def initialize(attributes = {})
    @attributes = attributes
    @id = attributes[:id]
    @title = attributes[:webTitle]
    @url = attributes[:webUrl]
    @section_id = attributes[:sectionId]
    @publication_date = attributes[:webPublicationDate]
    if @publication_date && !@publication_date.respond_to?(:yday)
      @publication_date = DateTime.parse(@publication_date)
    end
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

  # Returns the Section in which the content item was published.
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
    return collate_results_from_response(response)
  end

  def self.find_all_by_id(id, options = {})
    response = response_for_id_find(id, options)
    return collate_results_from_response(response)
  end

  # Fetch a Content item using its id. IDs are usually in the form of <tt>section/YYYY/month/DD/name-of-article</tt>.
  def self.find_by_id(id, options = {})
    response = response_for_id_find(id, options)
    content = response[:content]

    return GuardianContent::Content.new(recursively_symbolize_keys!(content))

  end

  private

  def self.collate_results_from_response(response)
    results = recursively_symbolize_keys!(response[:results])
    return results.map do |result|
      GuardianContent::Content.new(recursively_symbolize_keys!(result))
    end
  end

  def self.response_for_id_find(id, options)
    query = options
    query["show-fields"] = "all"
    query["show-tags"] = "all"
    query[:format] = "json"
    opts = {:query => query}

    attributes = {}
    return recursively_symbolize_keys!self.get("/#{id}", opts).nested_symbolize_keys![:response]
  end
end
