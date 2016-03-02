module Mailflow

  class UnprocessableError < StandardError; end

  class Attribute

    include Mailflow::APIOperations

    attr_accessor :name

    class << self
      def list(options = {})
        response = get_request('attributes', options)
        response.parsed_response.map do |params|
          Attribute.new(params)
        end
      end

      def update(attributes, params)
        body = {attributes: attributes}.merge(params)
        response = post_request('attributes', body)
        raise UnprocessableError if (response.code == 422 || response.code == 404)
        response.parsed_response.map do |attributes|
          Attribute.new(attributes)
        end
      end

      def delete(attributes, params = {})
        body = {attributes: attributes}.merge(params)
        response = delete_request('attributes', body)
        raise UnprocessableError if (response.code == 422 || response.code == 404)
        return true
      end

    end

    def initialize(attributes)
      @key = attributes["key"]
      @label = attributes["label"]
      @value = attributes["value"]
    end

    def ==(other)
      self.name == other.name
    end

  end

end
