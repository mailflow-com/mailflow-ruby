require "mailflow-ruby/configurable.rb"
require "mailflow-ruby/api_operations.rb"
require "mailflow-ruby/contact.rb"
require "mailflow-ruby/client.rb"
require "mailflow-ruby/version.rb"

module Mailflow

  include Configurable

  def self.setup(api_key, api_secret)
    Mailflow.configure({username: api_key, password: api_secret})
  end

end