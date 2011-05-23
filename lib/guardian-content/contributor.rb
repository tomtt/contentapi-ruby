class GuardianContent::Contributor < GuardianContent::Tag

  attr_reader :title, :id, :url

  def initialize(attributes = {})
    @id = attributes[:id] || nil
    @title = attributes[:web_title] || nil
    @url = attributes[:web_url] || nil
  end

  def inspect
    "#<Contributor id:" + self.id.to_s + " title:\"" + self.title.to_s + "\">"
  end

  def self.find_by_id(id)

    query = {}
    query["show-fields"] = "all"
    query[:format] = "json"
    opts = {:query => query}

    return GuardianContent::Contributor.new(self.get("/#{id}").nested_symbolize_keys![:response][:tag])

  end

end
