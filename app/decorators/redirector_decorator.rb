# frozen_string_literal: true

module Redirector
  class Middleware
    Responder.class_eval do
      private

      def request_path
        @request_path ||= if Redirector.include_query_in_source
                            "#{env["rack.url_scheme"]}://#{env["HTTP_HOST"]}#{env["ORIGINAL_FULLPATH"]}"
                          else
                            "#{env["rack.url_scheme"]}://#{env["HTTP_HOST"]}#{env["PATH_INFO"]}"
                          end
      end
    end
  end
end
