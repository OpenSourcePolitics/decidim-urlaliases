# frozen_string_literal: true

namespace :url_aliases do
  task init: ["install:migrations", "generate:reserved_paths"]

  namespace :install do
    desc "Install and run migrations"
    task :migrations do
      system("bundle exec rake redirector_engine:install:migrations")
      system("bundle exec rake decidim_url_aliases:install:migrations")
      system("bundle exec rake db:migrate")
    end
  end

  namespace :generate do
    desc "Generates a YAML file with the reserved paths"
    task reserved_paths: :environment do
      recognizer = Decidim::UrlAliases::RouteRecognizer.new
      recognizer.reserved_path?("")

      result = recognizer.instance_variables.each_with_object({}) do |element, memo|
        next if element.to_s.include?("routes")

        memo[element.to_s.remove("@")] = recognizer.instance_variable_get(element)
      end

      File.write(filepath("reserved_paths"), result.to_yaml)
      puts "File generated 'config/url_aliases/reserved_paths.yml'"
    end

    def filepath(filename)
      Dir.mkdir("config/url_aliases") unless File.directory?("config/url_aliases")
      Rails.root.join("config", "url_aliases", "#{filename}.yml")
    end
  end
end
