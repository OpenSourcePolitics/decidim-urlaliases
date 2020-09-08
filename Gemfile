# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", git: "https://github.com/OpenSourcePolitics/decidim.git", branch: "0.18-merge"
gem "decidim-url_aliases", path: "."

group :development, :test do
  gem "decidim-dev", git: "https://github.com/OpenSourcePolitics/decidim.git", branch: "0.18-merge"
  gem "bootsnap", require: true
  gem "byebug", "~> 10.0", platform: :mri
  gem "faker", "~> 1.8"
  gem "listen"
end

group :development do
  gem "letter_opener_web", "~> 1.3.3"
  gem "web-console", "~> 3.5"
end
