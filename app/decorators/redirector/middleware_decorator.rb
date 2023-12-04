# frozen_string_literal: true

# This decorator allows to differentiate between redirect rules of different organizations.
module Redirector::MiddlewareDecorator
  def self.decorate
    Redirector::Middleware::Responder.class_eval do
      private
    
      # Method overrided.
      # Returns a String of the destination if the found redirect rule organization's host
      # matches the request_host; nil otherwise.
      def matched_destination
        @matched_destination ||= with_optional_silencing do
          rules = RedirectRule.match_for(request_path, env)
          rule = same_organization_rules(rules, request_host).first
    
          return if rule.blank?
    
          rule.destination
        end
      end
    
      def same_organization_rules(rules, request_host)
        rules.select { |rule| rule.organization == request_organization(request_host) }
      end
    
      def request_organization(request_host)
        @request_organization ||= Decidim::Organization.find_by(host: request_host)
      end
    
      # Method overrided.
      # Returns a Rack response Array with HTTP status 302 instead of 301 to prevent caching.
      def redirect_response
        [302, { "Location" => redirect_url_string },
        [%(You are being redirected <a href="#{redirect_url_string}">#{redirect_url_string}</a>)]]
      end
    end

    RedirectRule.class_eval do
      def self.match_for(source, environment)
        # rubocop:disable Style/HashSyntax
        # rubocop:disable Style/BracesAroundHashParameters
        # rubocop:disable Lint/BooleanSymbol
        match_scope = where(match_sql_condition.strip, { :true => true, :false => false, :source => source })
        # rubocop:enable Style/HashSyntax
        # rubocop:enable Style/BracesAroundHashParameters
        # rubocop:enable Lint/BooleanSymbol
        # rubocop:disable Style/StringLiterals
        match_scope = match_scope.order(Arel.sql('redirect_rules.source_is_regex ASC, LENGTH(redirect_rules.source) DESC'))
        # rubocop:enable Style/StringLiterals
        match_scope = match_scope.includes(:request_environment_rules)
        match_scope = match_scope.references(:request_environment_rules) if Rails.version.to_i == 4
        match_scope.select { |rule| rule.request_environment_rules.all? { |env_rule| env_rule.matches?(environment) } }.sort_by(&:updated_at).reverse
      end
    end
  end
end

Redirector::MiddlewareDecorator.decorate
