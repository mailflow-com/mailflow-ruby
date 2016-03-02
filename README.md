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

### Basic examples

List all your contacts:

```ruby
Mailflow::Contact.list
```

Get a specific contact by email address:

```ruby
Mailflow::Contact.get({email: 'foo@example.com'})
```

More documentation coming soon. Contact *support@mailflow.com* for more information.
