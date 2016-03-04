module Mailflow

  class << self
    attr_accessor :test_mode
  end

  class Client

    include Mailflow::APIOperations

    def self.test
      response = get_request('test')
      return {status: response.code}
    end

  end

end
