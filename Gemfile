# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", git: "https://github.com/decidim/decidim.git", branch: "release/0.23-stable"
gem "decidim-url_aliases", path: "."

group :development, :test do
  gem "bootsnap", require: true
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", git: "https://github.com/decidim/decidim.git", branch: "release/0.23-stable"

  gem "faker", "~> 1.8"
  gem "listen"
end

group :development do
  gem "letter_opener_web", "~> 1.3.3"
  gem "web-console", "~> 3.5"
end
