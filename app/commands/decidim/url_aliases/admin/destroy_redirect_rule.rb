# frozen_string_literal: true

module Decidim
  module UrlAliases
    module Admin
      class DestroyRedirectRule < Rectify::Command
        def initialize(redirect_rule, current_user)
          @redirect_rule = redirect_rule
          @current_user = current_user
        end

        def call
          destroy_redirect_rule

          broadcast(:ok)
        rescue ActiveRecord::RecordNotDestroyed
          broadcast(:invalid)
        end

        private

        attr_reader :current_user

        def destroy_redirect_rule
          Decidim.traceability.perform_action!(
            :delete,
            @redirect_rule,
            current_user
          ) do
            @redirect_rule.destroy!
          end
        end
      end
    end
  end
end
