# frozen_string_literal: true

require "decidim/dev/common_rake"

desc "Generates a development app."
task development_app: "decidim:generate_external_development_app"

task test_app: "decidim:generate_external_test_app" do
  ENV["RAILS_ENV"] = "test"
  Dir.chdir("spec/decidim_dummy_app") do
    system("bundle exec rake redirector_engine:install:migrations")
    system("bundle exec rake decidim_url_aliases:install:migrations")
    system("bundle exec rake db:migrate")
  end
end
