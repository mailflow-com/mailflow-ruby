require 'spec_helper'

describe Mailflow::Contact do

  before do
    WebMock.reset!
  end

  let(:contact_response) { {"id" => "1ef1280b-d814-4e33-9f30-739c5b20188c","email" => "foo@example.com","created_at" => "2015-11-18T15:58:13.845Z","confirmed" => true} }
  let(:contacts_response) { [contact_response] }
  let(:contact) { Mailflow::Contact.new(contact_response) }
  let(:contacts) { [ contact ] }

  context '.list' do

    it 'returns a list of contacts if contacts found' do
      stub_request(:get, "https://mailflow.com/api/contacts").to_return(:body => contacts_response.to_json, :status => 200, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Contact.list
      expected = contacts
      expect(response).to eq(expected)
    end

    it 'returns an empty array if no contacts found' do
      stub_request(:get, "https://mailflow.com/api/contacts").to_return(:body => [].to_json, :status => 200, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Contact.list
      expected = []
      expect(response).to eq(expected)
    end

  end

  context '.get' do
    it 'returns a contact matching email' do
      email = 'foo@example.com'
      stub_request(:get, "https://mailflow.com/api/contacts?email=#{email}").to_return(:body => contact_response.to_json, :status => 200, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Contact.get({email: email})
      expected = contact
      expect(response).to eq(expected)
    end

    it 'returns a contact matching contact_id' do
      id = "1ef1280b-d814-4e33-9f30-739c5b20188c"
      stub_request(:get, "https://mailflow.com/api/contacts?contact_id=#{id}").to_return(:body => contact_response.to_json, :status => 200, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Contact.get({contact_id: id})
      expected = contact
      expect(response).to eq(expected)
    end

    it 'returns nil if no contact found' do
      email = 'foo@example.com'
      stub_request(:get, "https://mailflow.com/api/contacts?email=#{email}").to_return(:status => 404, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Contact.get({email: email})
      expected = nil
      expect(response).to eq(expected)
    end
  end

  context '.create' do

    it 'creates a contact by email address' do
      body = { "email" => "foo@example.com" }
      stub_request(:post, "https://mailflow.com/api/contacts").
        with(:body => body.to_json, :headers => { "Content-Type" => "application/json" }).
        to_return(:status => 200, :body => contact_response.to_json, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Contact.create(body)
      expect(response).to eq(contacts.first)
    end

    it 'creates a confirmed contact if confirmed flag is true' do
      body = { "email" => "foo@example.com", "confirmed" => true  }
      stub_request(:post, "https://mailflow.com/api/contacts").
        with(:body => body.to_json, :headers => { "Content-Type" => "application/json" }).
        to_return(:status => 200, :body => contact_response.to_json, :headers => { "Content-Type" => "application/json" })
      response = Mailflow::Contact.create(body)
      expect(response).to eq(contacts.first)
    end

    it 'returns 422 if email is invalid' do
      body = { "email" => "" }
      stub_request(:post, "https://mailflow.com/api/contacts").
        with(:body => body.to_json, :headers => { "Content-Type" => "application/json" }).
        to_return(:status => 422, :headers => { "Content-Type" => "application/json" })
      expect{Mailflow::Contact.create(body)}.to raise_error(Mailflow::UnprocessableError)
    end

  end

  it 'deletes a contact' do
    body = {contact_id: contact.id}
    stub_request(:delete, "https://mailflow.com/api/contacts").
      with(:body => body.to_json, :headers => { "Content-Type" => "application/json" }).
      to_return(:status => 204)
    response = contact.delete
    expect(response).to eq(nil)
  end

  context '#tags' do
    it 'calls tags.list for an instance' do
      tagger = class_double('Mailflow::Tag').as_stubbed_const(:transfer_nested_constants => true)
      expect(tagger).to receive(:list).with(contact_id: contact.id)
      contact.tags
    end
  end

  context '#tag' do
    it 'tags with an array of strings' do
      tagger = class_double('Mailflow::Tag').as_stubbed_const(:transfer_nested_constants => true)
      expect(tagger).to receive(:create).with(["Foo Bar"], {contact_id: contact.id}, false)
      contact.tag(["Foo Bar"])
    end

    it 'triggers if flag is provided' do
      tagger = class_double('Mailflow::Tag').as_stubbed_const(:transfer_nested_constants => true)
      expect(tagger).to receive(:create).with(["Foo Bar"], {contact_id: contact.id}, true)
      contact.tag(["Foo Bar"], true)
    end
  end

  context '#untag' do
    it 'removes all tags in array' do
      tagger = class_double('Mailflow::Tag').as_stubbed_const(:transfer_nested_constants => true)
      expect(tagger).to receive(:untag).with(["Foo Bar"], {contact_id: contact.id})
      contact.untag(["Foo Bar"])
    end
  end

  context '#attributes' do
    it 'calls attributes.list for an instance' do
      tagger = class_double('Mailflow::Attribute').as_stubbed_const(:transfer_nested_constants => true)
      expect(tagger).to receive(:list).with(contact_id: contact.id)
      contact.attributes
    end
  end

  context '#set_attributes' do
    it 'calls attributes.update for the instance' do
      attributes = [{key: 'first', value: 'chris'}, {key: 'second', value: 'foo'}]
      attributer = class_double('Mailflow::Attribute').as_stubbed_const(:transfer_nested_constants => true)
      expect(attributer).to receive(:update).with(attributes, {contact_id: contact.id})
      contact.set_attributes({first: 'chris', second: 'foo'})
    end
  end

  ## Test that all of these return the contact


end
