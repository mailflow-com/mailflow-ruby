# Mailflow Ruby library

This is Mailflow's official Ruby library. It allows convenient access to the Mailflow API, which allows you to:

* Get, create and delete contacts
* Update attributes for a specific contact
* Tag and untag a specific contact
* Trigger sequences on contact tag

## Getting started

### Install the gem

    gem install mailflow-ruby

### Provide API credentials

You can find your API credentials in the [Integrations section](https://mailflow.com/integrations/mailflow) of the Mailflow app.

```ruby
require 'mailflow-ruby'

Mailflow.setup('API_KEY', 'SECRET_KEY')
```

### List all contacts

```ruby
Mailflow::Contact.list
```

## Contacts

#### Basic contact operations


Get a contact by email address or contact ID:

```ruby
Mailflow::Contact.get({email: 'foo@example.com'})
Mailflow::Contact.get({contact_id: 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'})
```


Create an unconfirmed contact (this will send the contact an opt-in email):

```ruby
Mailflow::Contact.create({email: 'foo@example.com'})
```


Create a confirmed contact (and don't send an opt-in email)

```ruby
Mailflow::Contact.create({email: 'foo@example.com', confirmed: true})
```


### Contact tag operations


List a contact's tags:

```ruby
contact = Mailflow::Contact.get({email: 'foo@example.com'})
contact.tags
```


Tag a contact (accepts an array only):

```ruby
contact = Mailflow::Contact.get({email: 'foo@example.com'})
contact.tag(['Foo', 'Bar'])
```


Tag a contact and trigger any relevant sequences:

```ruby
contact = Mailflow::Contact.get({email: 'foo@example.com'})
contact.tag(['Foo', 'Bar'], true)
```


Untag a contact (accepts an array only):

```ruby
contact = Mailflow::Contact.get({email: 'foo@example.com'})
contact.untag(['Foo', 'Bar'])
```


### Contact attribute operations


List a contact's attributes:

```ruby
contact = Mailflow::Contact.get({email: 'foo@example.com'})
contact.attributes
```


Set attributes on a contact:

```ruby
contact = Mailflow::Contact.get({email: 'foo@example.com'})
contact.set_attributes({'First name' => 'Foo', 'Last name' => 'Bar' })
```

## More information

Contact support@mailflow.com for more information.
