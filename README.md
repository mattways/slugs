[![Gem Version](https://badge.fury.io/rb/slugs.svg)](http://badge.fury.io/rb/slugs)
[![Code Climate](https://codeclimate.com/github/mmontossi/slugs/badges/gpa.svg)](https://codeclimate.com/github/mmontossi/slugs)
[![Build Status](https://travis-ci.org/mmontossi/slugs.svg)](https://travis-ci.org/mmontossi/slugs)
[![Dependency Status](https://gemnasium.com/mmontossi/slugs.svg)](https://gemnasium.com/mmontossi/slugs)

# Slugs

Manages slugs for records with minimal efford in rails.

## Why

I did this gem to:

- Control when routes will use the slug or id.
- Keep old slugs until the record is destroyed.
- Avoid collision by appending an index.

## Install

Put this line in your Gemfile:
```ruby
gem 'slugs'
```

Then bundle:
```
$ bundle
```

## Configuration

Run the install generator:
```
$ bundle exec rails g slugs:install
```

Set the global settings:
```ruby
Slugs.configure do |config|
  config.use_slug? do |record, params|
    params[:controller] != 'admin'
  end
end
```

Add the columns to your tables:
```ruby
class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :model
      t.string :slug

      t.timestamps null: false
    end
  end
end
```

Update your db:
```
$ bundle exec rake db:migrate
```

Define slugs in your models:
```ruby
class Product < ActiveRecord::Base
  has_slug :model, :name, scope: :shop_id
end
```

## Usage

A slug will be generated every time you create/update a record:
```ruby
product = Product.create(name: 'Stratocaster', model: 'American Standar', ...)
product.slug # => 'american-standard-stratocaster'
```

An index will be appended if another record with the same slug is created:
```ruby
product = Product.create(name: 'Stratocaster', model: 'American Standard', ...)
product.slug # => 'american-standard-stratocaster-1'
```

Every time you change a record, the slug will be updated:
```ruby
product.update name: 'Strat'
product.slug # => 'american-standard-strat'
```

Finders will start accepting slugs and remember old ones:
```ruby
Product.find 'american-standard-stratocaster' # => product
Product.find 'american-standard-strat' # => product
```

In routes use_slug? block will be use to determine when to sluggize:
```ruby
admin_product_path product # => 'admin/products/34443'
product_path product # => 'products/american-standard-strat'
```

## Credits

This gem is maintained and funded by [mmontossi](https://github.com/mmontossi).

## License

It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
