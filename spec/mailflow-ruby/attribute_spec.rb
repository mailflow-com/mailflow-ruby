require 'spec_helper'

describe Mailflow::Attribute do

  before do
    WebMock.reset!
    Mailflow.setup('api_key', 'secret_key')
  end

  let(:empty_attribute_response) { {"key" => "first_name", "label" => "First name" } }
  let(:empty_attributes_response) { [empty_attribute_response] }
  let(:empty_attribute) { Mailflow::Attribute.new(empty_attribute_response) }
  let(:empty_attributes) { [empty_attribute] }

  let(:attribute_response) { {"key" => "first_name", "label" => "First name", "value" => "Cybil" } }
  let(:attributes_response) { [attribute_response] }
  let(:attribute) { Mailflow::Attribute.new(attribute_response) }
  let(:attributes) { [attribute] }


  context '.list' do

    it 'returns a list of attributes if attributes found' do
      stub_request(:get, "https://mailflow.com/api/attributes").to_return(:body => empty_attributes_response.to_json, :status => 200, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Attribute.list
      expected = empty_attributes
      expect(response).to eq(expected)
    end

    it 'returns an empty array if no attributes found' do
      stub_request(:get, "https://mailflow.com/api/attributes").to_return(:body => [].to_json, :status => 200, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Attribute.list
      expected = []
      expect(response).to eq(expected)
    end

    it 'lists all attributes for a contact by contact email address' do
      email = 'chris@mailflow.com'
      stub_request(:get, "https://mailflow.com/api/attributes?email=#{email}").to_return(:body => attributes_response.to_json, :status => 200, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Attribute.list({email: email})
      expected = attributes
      expect(response).to eq(expected)
    end

    it 'lists all attributes for a contact by contact id' do
      contact_id = '12345'
      stub_request(:get, "https://mailflow.com/api/attributes?contact_id=#{contact_id}").to_return(:body => attributes_response.to_json, :status => 200, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Attribute.list({contact_id: contact_id})
      expected = attributes
      expect(response).to eq(expected)
    end
  end

  context '.update' do

    it 'sends update attribute for a contact by email address' do  
      email = 'chris@mailflow.com'
      _attributes = [{key: 'name', value: 'bar'}]
      body = {attributes: _attributes, email: email}
      stub_request(:post, "https://mailflow.com/api/attributes").
        with(:body => body.to_json, :headers => { "Content-Type" => "application/json" }).
        to_return(:status => 201, :body => attributes_response.to_json, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Attribute.update(_attributes, {email: email})
      expected = attributes
      expect(response).to eq(expected)
    end

    it 'sends update attribute for a contact by contact id' do  
      contact_id = '1241'
      _attributes = [{key: 'name', value: 'bar'}]
      body = {attributes: _attributes, contact_id: contact_id}
      stub_request(:post, "https://mailflow.com/api/attributes").
        with(:body => body.to_json, :headers => { "Content-Type" => "application/json" }).
        to_return(:status => 201, :body => attributes_response.to_json, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Attribute.update(_attributes, {contact_id: contact_id})
      expected = attributes
      expect(response).to eq(expected)
    end

  end

  context '#delete' do
    it 'deletes an attribute from all contacts' do
      response = double('MagicClass')
      body = {attributes: [{key: 'first_name'}]}
      attributer = class_double('HTTParty').as_stubbed_const(:transfer_nested_constants => true)
      expect(attributer).to receive(:delete).with("https://mailflow.com/api/attributes", {:body=>body.to_json, :headers=>{"Content-Type"=>"application/json", "Accept"=>"application/json"}}).and_return(response)
      expect(response).to receive(:code).twice.and_return(204)
      response = Mailflow::Attribute.delete([{key: 'first_name'}])
    end

    it 'deletes an attribute from a contact by email address' do
      response = double('MagicClass')
      body = {attributes: [{key: 'first_name'}], email: 'chris@mailflow.com'}
      attributer = class_double('HTTParty').as_stubbed_const(:transfer_nested_constants => true)
      expect(attributer).to receive(:delete).with("https://mailflow.com/api/attributes", {:body=>body.to_json, :headers=>{"Content-Type"=>"application/json", "Accept"=>"application/json"}}).and_return(response)
      expect(response).to receive(:code).twice.and_return(204)
      response = Mailflow::Attribute.delete([{key: 'first_name'}], {email: 'chris@mailflow.com'})
    end

    it 'deletes an attribute from a contact by contact id' do
      response = double('MagicClass')
      body = {attributes: [{key: 'first_name'}], contact_id: '12345'}
      attributer = class_double('HTTParty').as_stubbed_const(:transfer_nested_constants => true)
      expect(attributer).to receive(:delete).with("https://mailflow.com/api/attributes", {:body=>body.to_json, :headers=>{"Content-Type"=>"application/json", "Accept"=>"application/json"}}).and_return(response)
      expect(response).to receive(:code).twice.and_return(204)
      response = Mailflow::Attribute.delete([{key: 'first_name'}], {contact_id: '12345'})
    end
  end

end