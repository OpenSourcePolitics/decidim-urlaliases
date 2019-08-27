# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/url_aliases/version"

Gem::Specification.new do |s|
  s.version = Decidim::UrlAliases.version
  s.authors = %w(OSP CodiTramuntana)
  s.email = ["contact@opensourcepolitics.eu", "info@coditramuntana.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/OpenSourcePolitics/decidim-urlaliases"
  s.required_ruby_version = ">= 2.5.3"

  s.name = "decidim-url_aliases"
  s.summary = "Decidim UrlAliases"
  s.description = "Decidim UrlAliases"

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  DECIDIM_VERSION = ">= 0.16.1"

  s.add_dependency "decidim-core", DECIDIM_VERSION
  s.add_dependency "rails", ">= 5.2"
  s.add_dependency "redirector"
  s.add_development_dependency "database_cleaner"

  s.add_development_dependency "decidim-dev", DECIDIM_VERSION
end
