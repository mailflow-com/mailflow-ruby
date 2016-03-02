require 'spec_helper'

describe Mailflow::Client do

  before do
    WebMock.reset!
  end

  let(:empty_attribute_response) { {"key" => "first_name", "label" => "First name" } }

  context '.test' do

    before { Mailflow.test_mode = true }

    it 'returns response code as nice object' do
      stub_request(:get, "https://mailflow.com/api/test").to_return(:status => 200, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Client.test
      expected = {status: 200}
      expect(response).to eq(expected)
    end

  end

end
