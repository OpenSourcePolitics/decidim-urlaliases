# frozen_string_literal: true

module Decidim
  module UrlAliases
    module Admin
      class UpdateRedirectRule < Rectify::Command
        def initialize(redirect_rule, form)
          @redirect_rule = redirect_rule
          @form = form
        end

        def call
          return broadcast(:invalid) if form.invalid?

          update_redirect_rule

          broadcast(:ok)
        rescue ActiveRecord::RecordInvalid
          broadcast(:invalid)
        end

        private

        attr_reader :form

        def update_redirect_rule
          Decidim.traceability.update!(
            @redirect_rule,
            form.current_user,
            attributes
          )
        end

        def attributes
          {
            source: form.source,
            source_is_case_sensitive: form.source_is_case_sensitive,
            destination: form.destination,
            active: form.active
          }
        end
      end
    end
  end
end
