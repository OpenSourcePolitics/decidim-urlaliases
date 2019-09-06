# frozen_string_literal: true

# This decorator allows to differentiate between redirect rules of different organizations.
Redirector::Middleware::Responder.class_eval do
  private

  # Method overrided.
  # Returns a String of the destination if the found redirect rule organization's host
  # matches the request_host; nil otherwise.
  def matched_destination
    @matched_destination ||= with_optional_silencing do
      rule = RedirectRule.match_for(request_path, env)
      rule.destination if rule && rule.organization.host == request_host
    end
  end

  # Method overrided.
  # Returns a Rack response Array with HTTP status 302 instead of 301 to prevent caching.
  def redirect_response
    [302, {'Location' => redirect_url_string},
     [%{You are being redirected <a href="#{redirect_url_string}">#{redirect_url_string}</a>}]]
  end
end
