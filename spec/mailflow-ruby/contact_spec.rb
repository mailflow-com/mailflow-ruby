require 'spec_helper'

describe Mailflow::Contact do

  before do
    WebMock.reset!
    Mailflow.setup('api_key', 'secret_key')
  end

  let(:contact_response) { {"id" => "1ef1280b-d814-4e33-9f30-739c5b20188c","email" => "chris@mailflow.com","created_at" => "2015-11-18T15:58:13.845Z","confirmed" => true} }
  let(:contacts_response) { [contact_response] }
  let(:contact) { Mailflow::Contact.new(contact_response) }
  let(:contacts) { [ contact ] }

  it 'returns a list of contacts' do
    stub_request(:get, "https://mailflow.com/api/contacts").to_return(:body => contacts_response.to_json, :status => 200, :headers => { "Content-Type" => "application/json" })
    response = Mailflow::Contact.list
    expected = contacts
    expect(response).to eq(expected)
  end

  it 'returns a contact matching email' do
    stub_request(:get, "https://mailflow.com/api/contacts?email=chris@mailflow.com").to_return(:body => contact_response.to_json, :status => 200, :headers => { "Content-Type" => "application/json" })
    email = 'chris@mailflow.com'
    response = Mailflow::Contact.get({email: email})
    expected = contact
    expect(response).to eq(expected)
  end

  it 'returns a contact matching contact_id' do
    stub_request(:get, "https://mailflow.com/api/contacts?contact_id=1ef1280b-d814-4e33-9f30-739c5b20188c").to_return(:body => contact_response.to_json, :status => 200, :headers => { "Content-Type" => "application/json" })
    id = "1ef1280b-d814-4e33-9f30-739c5b20188c"
    response = Mailflow::Contact.get({contact_id: id})
    expected = contact
    expect(response).to eq(expected)
  end

  it 'creates a contact' do

    body = { "email" => "chris@mailflow.com" }
    stub_request(:post, "https://mailflow.com/api/contacts").
      with(:body => body.to_json, :headers => { "Content-Type" => "application/json" }).
      to_return(:status => 200, :body => contact_response.to_json, :headers => { "Content-Type" => "application/json" })
    response = Mailflow::Contact.create({ "email" => "chris@mailflow.com" })

    expect(response).to eq(contacts.first)
  end

  it 'deletes a contact' do
    body = {contact_id: contact.id}
    stub_request(:delete, "https://mailflow.com/api/contacts").
      with(:body => body.to_json, :headers => { "Content-Type" => "application/json" }).
      to_return(:status => 204)

    contact.delete
  end

end