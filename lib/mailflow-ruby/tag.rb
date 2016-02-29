module Mailflow

  class UnprocessableError < StandardError; end

  class Tag

    include Mailflow::APIOperations

    attr_accessor :name

    class << self
      def list(options = {})
        response = get_request('tags', options)
        response.parsed_response.map do |attributes|
          Tag.new(attributes)
        end
      end

      def create(tags, params = {}, trigger = false)
        tags = tags.map { |tag| {name: tag}}
        body = {tags: tags}
        body.merge!(params)
        body.merge!({trigger: trigger}) if trigger
        
        response = post_request('tags', body)
        raise UnprocessableError if (response.code == 422 || response.code == 404)
        response.parsed_response.map do |attributes|
          Tag.new(attributes)
        end
      end

      def untag(tags, params = {})
        tags = tags.map { |tag| {name: tag}}
        delete_request('tags', {tags: tags}.merge(params))
      end

    end

    def initialize(attributes)
      @name = attributes["name"]
    end

    def ==(other)
      self.name == other.name
    end

    def delete
      Mailflow::Tag.delete_request('tags', {tags: [{name: name}]})
      return true
    end

  end

end