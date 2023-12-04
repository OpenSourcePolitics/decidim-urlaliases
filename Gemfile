# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: "https://github.com/decidim/decidim", branch: "release/0.27-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-url_aliases", path: "."

# temporal solution while gems embrace new psych 4 (the default in Ruby 3.1) behavior.
gem "psych", "< 4"

group :development, :test do
  gem "bootsnap", "~> 1.4", require: true
  gem "byebug", ">= 11.1.3", platform: :mri
  gem "decidim-dev", DECIDIM_VERSION
  gem "faker"
  gem "listen", "~> 3.1"
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "web-console", "~> 3.5"
end
