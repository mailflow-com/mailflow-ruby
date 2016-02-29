module Mailflow

  class UnprocessableError < StandardError; end

  class Contact

    include Mailflow::APIOperations

    attr_accessor :id, :email, :created_at, :confirmed

    class << self
      def list
        response = get_request('contacts')
        response.parsed_response.map do |attributes|
          Contact.new(attributes)
        end
      end

      def get(options = {})
        response = get_request('contacts', options)
        Contact.new(response.parsed_response) if response.code == 200
      end

      def create(attributes)
        response = post_request('contacts', attributes)
        raise UnprocessableError if (response.code == 422 || response.code == 404)
        Contact.new(response.parsed_response)
      end
    end

    def initialize(attributes)
      @id = attributes["id"]
      @email = attributes["email"]
      @created_at = attributes["created_at"]
      @confirmed = attributes["confirmed"]
    end

    def ==(other)
      self.id == other.id &&
      self.email == other.email &&
      self.confirmed == other.confirmed
    end

    def delete
      Mailflow::Contact.delete_request('contacts', {contact_id: id}).parsed_response
    end

    def tags
      Mailflow::Tag.list(contact_id: id)
    end

    def tag(tags)
      Mailflow::Tag.create(tags, {contact_id: id})
    end

    def untag(tags)
      Mailflow::Tag.untag(tags, {contact_id: id})
    end

    def attributes
      Mailflow::Attribute.list(contact_id: id)
    end

    def set_attributes(attributes)
      attributes = attributes.map do |key, value|
        {key: key.to_s, value: value}
      end

      Mailflow::Attribute.update(attributes, {contact_id: id})
    end

  end

end