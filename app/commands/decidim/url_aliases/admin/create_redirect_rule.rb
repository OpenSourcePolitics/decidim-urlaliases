# frozen_string_literal: true

module Decidim
  module UrlAliases
    module Admin
      class CreateRedirectRule < Rectify::Command
        def initialize(form)
          @form = form
        end

        def call
          return broadcast(:invalid) if form.invalid?

          create_redirect_rule
          broadcast(:ok)
        end

        private

        attr_reader :form

        def create_redirect_rule
          Decidim.traceability.create!(
            RedirectRule,
            form.current_user,
            {
              source: form.source,
              source_is_case_sensitive: form.source_is_case_sensitive,
              destination: form.destination,
              active: form.active,
              organization: form.organization
            },
            extra: {
              source: form.source,
              destination: form.destination
            }
          )
        end
      end
    end
  end
end
