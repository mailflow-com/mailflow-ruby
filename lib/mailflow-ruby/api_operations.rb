require 'httparty'
require 'byebug'

module Mailflow
  module APIOperations
    module ClassMethods

      def url(endpoint)
        "https://mailflow.com/api/#{endpoint}"
      end

      def get_request(endpoint, params = {})
        options = base_params.merge({query: params})
        HTTParty.get(url(endpoint), options)
      end

      def post_request(endpoint, params = {})
        options = base_params.merge({ body: params.to_json, headers: { "Content-Type" => "application/json", 'Accept'=>'application/json'} })
        HTTParty.post(url(endpoint), options)
      end

      def delete_request(endpoint, params = {})
        options = base_params.merge({ body: params.to_json, headers: { "Content-Type" => "application/json", 'Accept'=>'application/json'} })
        HTTParty.delete(url(endpoint), options)
      end

      def base_params
        (Mailflow.test_mode) ? {} : {digest_auth: {username: Mailflow.config.username, password: Mailflow.config.password}}
      end

    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
