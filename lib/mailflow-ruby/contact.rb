module Mailflow
  class Contact

    include Mailflow::APIOperations

    attr_accessor :id, :email, :created_at, :confirmed

    class << self
      def list
        response = get_request('contacts')
        response.parsed_response.flatten.map do |attributes|
          Contact.new(attributes)
        end
      end

      def get(options = {})
        response = get_request('contacts', options)
        Contact.new(response.parsed_response)
      end

      def create(attributes)
        response = post_request('contacts', attributes)
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
      Mailflow::Contact.delete_request('contacts', {contact_id: id})
    end

  end

end