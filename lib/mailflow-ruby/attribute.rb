module Mailflow

  class UnprocessableError < StandardError; end

  class Attribute

    include Mailflow::APIOperations

    attr_accessor :name

    class << self
      def list(options = {})
        response = get_request('attributes', options)
        response.parsed_response.flatten.map do |params|
          Attribute.new(params)
        end
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