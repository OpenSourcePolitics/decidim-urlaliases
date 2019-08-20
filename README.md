# Decidim::UrlAliases
Decidim gem to allow admins to create url aliases for participatory processes

## How it works

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decidim-urlaliases'
```

And then execute:

```bash
bundle
```

```bash
bundle exec rake redirector_engine:install:migrations
bundle exec rake decidim_url_aliases:install:migrations

bundle exec rake db:migrate
```

You can set these inside your configuration in config/application.rb of your Rails application like so:
```bash
  config.redirector.include_query_in_source = true
  config.redirector.silence_sql_logs = true
  config.redirector.ignored_patterns = [/^\/assets\/.+/]
```
## Testing

1. Run `bundle exec rake test_app`.

2. Run tests with `bundle exec rspec`

## Versioning

`Decidim::UrlAliases` depends directly on `Decidim::Core` in `0.16.1` version.

## Contributing

See [Decidim](https://github.com/decidim/decidim).

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
