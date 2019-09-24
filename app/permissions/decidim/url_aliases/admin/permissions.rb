# frozen_string_literal: true

module Decidim
  module UrlAliases
    module Admin
      class Permissions < Decidim::Admin::Permissions
        def permissions
          return permission_action unless user && permission_action.scope == :admin

          permission_action.allow! if can_perform_actions_on?(:redirect_rule, redirect_rule)

          permission_action
        end

        private

        def redirect_rule
          @redirect_rule ||= context.fetch(:redirect_rule, nil)
        end

        def can_perform_actions_on?(subject, resource)
          return unless permission_action.subject == subject

          case permission_action.action
          when :create, :read
            true
          when :update, :destroy
            resource.present?
          else
            false
          end
        end
      end
    end
  end
end
