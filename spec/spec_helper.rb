$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'mailflow-ruby'
require 'webmock/rspec'

Mailflow.test_mode = true
