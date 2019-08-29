# Decidim::UrlAliases

`Decidim::UrlAliases` is a [Decidim](https://github.com/decidim/decidim) module to allow admins to create url aliases for resources within a `Decidim::ParticipatorySpace`.

The module is based on the [Redirector gem](https://github.com/vigetlabs/redirector) and creates an interface for admins to manage redirect rules. Redirect rules have two parts: the _source_ defines how to match the incoming request path and the _destination_ is where to send the visitor if the match is made.

The gem enforces the following restrictions to redirect rules:
- Only paths that match public routes within _participatory spaces_ are allowed as **destination**.
- Paths that can conflict with existing _decidim_ routes are not allowed as **source**. After installation, take a look at `config/url_aliases/reserved_paths.yml` to see which ones they are **\***. You can add custom paths to this list by adding entries to "new_reserved_paths".
- Redirect rules will only have effect when visiting the host of the `Decidim::Organization` in which they were created.

**\*** Reserved paths are computed dinamically to allow for changes, but you can make yourself and idea by checking [default_reserved_paths.yml](config/default_reserved_paths.yml).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decidim-urlaliases'
```

And then execute:

```bash
bundle
bundle exec rake url_aliases:init
```

Inside your configuration in `config/application.rb` of your Rails application you can set the following:
```bash
# This option silences the logging of Redirector related SQL queries in your log file
config.redirector.silence_sql_logs = true
```

## Usage

- Install the gem
- Login to the application as an administrator.
- Go to the Admin panel > Url Aliases.
- Create a new redirect rule. Choose a custom path as a _source_, copy the path to a resource in your app as _destination_ and make sure to check "Active".
- Visit your custom path inside the organization host and see yourself redirected to the destination that you chose.

Disclaimer: be aware that you may have to clear your web browser cache after making changes to an existing redirect rule to be redirected to the new destination.

## Testing

1. Run `bundle exec rake test_app`.

2. Run tests with `bundle exec rspec`

## Versioning

`Decidim::UrlAliases` depends directly on `Decidim::Core` in `0.16.1` version.

## Contributing

See [Decidim](https://github.com/decidim/decidim).

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
