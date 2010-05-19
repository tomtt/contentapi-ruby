module GuardianContent
  
  require 'httparty'
  
  
  def self.new(*params)
    GuardianContent::Base.new(*params)
  end
  
  class Base
    include HTTParty
    base_uri 'http://content.guardianapis.com/'
  
    def initialize(key = nil)
      if defined?(GUARDIAN_CONTENT_API_KEY)
        key = GUARDIAN_CONTENT_API_KEY
      end
      self.class.default_params "api-key" => key, "format" => "json"
    end    

    def reload(options = nil)
      @attributes.update(self.class.find_by_id(self.id, options).instance_variable_get('@attributes'))
      self
    end


  end
end

%w(extensions content section tag keyword contributor).each do |file|
  require File.join(File.dirname(__FILE__), 'guardian-content', file)
end