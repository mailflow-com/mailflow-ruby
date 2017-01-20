require 'hashie'

module Configurable
  def self.included(base)
    base.const_set(:Configuration, Class.new(Hashie::Mash)) unless base.const_defined?(:Configuration)
    base.extend(ClassMethods)
  end

  protected

  module ClassMethods
    def configuration_class
      self.const_get(:Configuration)
    end

    def configuration
      @configuration ||= configuration_class.new
    end

    def configuration=(configuration)
      @configuration = configuration_class.new(configuration)
    end

    alias_method :config, :configuration

    def configure(configuration = {}, &block)
      self.configuration = configuration unless configuration.empty?
      block.call(self.configuration) if block_given?
    end

  end
end
