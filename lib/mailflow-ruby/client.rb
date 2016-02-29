require 'base64'
require 'json'
require 'httparty'
require 'byebug'

module Mailflow

  class << self
    attr_accessor :test_mode
  end
  
  class Client

    include Mailflow::APIOperations

    def self.test
      get('test')
    end

  end

end