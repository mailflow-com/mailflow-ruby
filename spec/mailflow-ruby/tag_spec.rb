require 'spec_helper'

describe Mailflow::Tag do

  before do
    WebMock.reset!
    Mailflow.setup('api_key', 'secret_key')
  end

  let(:tag_response) { {"name" => "Foo Bar" } }
  let(:tags_response) { [tag_response] }
  let(:tag) { Mailflow::Tag.new(tag_response) }
  let(:tags) { [tag] }

  context '.list' do

    it 'returns a list of tags if tags found' do
      stub_request(:get, "https://mailflow.com/api/tags").to_return(:body => tags_response.to_json, :status => 200, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Tag.list
      expected = tags
      expect(response).to eq(expected)
    end

    it 'returns an empty array if no tags found' do
      stub_request(:get, "https://mailflow.com/api/tags").to_return(:body => [].to_json, :status => 200, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Tag.list
      expected = []
      expect(response).to eq(expected)
    end

    it 'lists all tags for a contact by contact email address' do
      email = 'chris@mailflow.com'
      stub_request(:get, "https://mailflow.com/api/tags?email=#{email}").to_return(:body => tags_response.to_json, :status => 200, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Tag.list({email: email})
      expected = tags
      expect(response).to eq(expected)
    end

    it 'lists all tags for a contact by contact id' do
      contact_id = '12345'
      stub_request(:get, "https://mailflow.com/api/tags?contact_id=#{contact_id}").to_return(:body => tags_response.to_json, :status => 200, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Tag.list({contact_id: contact_id})
      expected = tags
      expect(response).to eq(expected)
    end

  end

  context '.create' do

    it 'creates a tag without a contact' do
      tags_array = ["Foo Bar"]
      body = {tags: tags_response}
      stub_request(:post, "https://mailflow.com/api/tags").
        with(:body => body.to_json, :headers => { "Content-Type" => "application/json" }).
        to_return(:status => 201, :body => tags_response.to_json, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Tag.create(tags_array)
      expected = tags
      expect(response).to eq(expected)
    end

    it 'creates a tag with a contact by email address' do
      tags_array = ["Foo Bar"]
      email_address = "chris@mailflow.com"
      body = {tags: tags_response, email: email_address}
      stub_request(:post, "https://mailflow.com/api/tags").
        with(:body => body.to_json, :headers => { "Content-Type" => "application/json" }).
        to_return(:status => 201, :body => tags_response.to_json, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Tag.create(tags_array, {email: email_address})
      expected = tags
      expect(response).to eq(expected)
    end

    it 'creates a tag with a contact by contact_id' do
      tags_array = ["Foo Bar"]
      contact_id = "12345"
      body = {tags: tags_response, contact_id: contact_id}
      stub_request(:post, "https://mailflow.com/api/tags").
        with(:body => body.to_json, :headers => { "Content-Type" => "application/json" }).
        to_return(:status => 201, :body => tags_response.to_json, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Tag.create(tags_array, {contact_id: contact_id})
      expected = tags
      expect(response).to eq(expected)
    end

    it 'request includes trigger option if specified' do
      tags_array = ["Foo Bar"]
      email_address = "chris@mailflow.com"
      body = {tags: tags_response, email: email_address, trigger: true}
      stub_request(:post, "https://mailflow.com/api/tags").
        with(:body => body.to_json, :headers => { "Content-Type" => "application/json" }).
        to_return(:status => 201, :body => tags_response.to_json, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Tag.create(tags_array, {email: email_address}, true)
      expected = tags
      expect(response).to eq(expected)
    end

  end

  context '.untag' do
    it 'removes a tag from contact by email address' do
      tags_array = ["Foo Bar"]
      email_address = "chris@mailflow.com"
      arguments = {tags: tags_array, email: email_address}

      tagger = class_double('HTTParty').as_stubbed_const(:transfer_nested_constants => true)
      expect(tagger).to receive(:delete).with("https://mailflow.com/api/tags", {:body=>"{\"tags\":[{\"name\":\"Foo Bar\"}],\"email\":\"chris@mailflow.com\"}", :headers=>{"Content-Type"=>"application/json", "Accept"=>"application/json"}})

      Mailflow::Tag.untag(tags_array, {email: email_address})
    end

    it 'removes a tag from contact by contact_id' do
      tags_array = ["Foo Bar"]
      contact_id = "12345"

      arguments = {tags: tags_array, contact_id: contact_id}

      tagger = class_double('HTTParty').as_stubbed_const(:transfer_nested_constants => true)
      expect(tagger).to receive(:delete).with("https://mailflow.com/api/tags", {:body=>"{\"tags\":[{\"name\":\"Foo Bar\"}],\"contact_id\":\"12345\"}", :headers=>{"Content-Type"=>"application/json", "Accept"=>"application/json"}})

      Mailflow::Tag.untag(tags_array, {contact_id: contact_id})
    end
  end

  context '#delete' do
    it 'deletes a tag from all contacts' do
      body = {tags: tags_response}
      stub_request(:delete, "https://mailflow.com/api/tags").
        with(:body => body.to_json, :headers => { "Content-Type" => "application/json" }).
        to_return(:status => 204)
      response = tag.delete
      expect(response).to eq(nil)
    end
  end

end