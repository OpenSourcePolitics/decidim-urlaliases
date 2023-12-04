# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/url_aliases/version"

Gem::Specification.new do |s|
  s.version = Decidim::UrlAliases.version
  s.authors = %w(OSP CodiTramuntana)
  s.email = ["contact@opensourcepolitics.eu", "info@coditramuntana.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/OpenSourcePolitics/decidim-urlaliases"
  s.required_ruby_version = ">= 3.0.6"

  s.name = "decidim-url_aliases"
  s.summary = "Decidim UrlAliases"
  s.description = "Decidim UrlAliases"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  DECIDIM_VERSION = ">= 0.27"

  s.add_dependency "decidim-core", DECIDIM_VERSION
  s.add_dependency "redirector"

  s.add_development_dependency "decidim", DECIDIM_VERSION
  s.add_development_dependency "decidim-dev", DECIDIM_VERSION
end
