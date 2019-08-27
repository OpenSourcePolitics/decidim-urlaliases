# frozen_string_literal: true

module Decidim
  module UrlAliases
    module AdminLog
      # This class holds the logic to present a `RedirectRule` for the `AdminLog` log.
      class RedirectRulePresenter < Decidim::Log::BasePresenter
        private

        delegate :resource, :resource_id, to: :action_log
        delegate :url_helpers, to: "Decidim::UrlAliases::AdminEngine.routes"

        def diff_fields_mapping
          {
            source: :string,
            source_is_case_sensitive: :boolean,
            destination: :string,
            active: :boolean
          }
        end

        def action_string
          case action
          when "create", "update", "delete"
            "decidim.url_aliases.admin_log.#{action}"
          end
        end

        def i18n_labels_scope
          "url_aliases.admin.models.redirect_rule.fields"
        end

        # Private: The params to be sent to the i18n string.
        #
        # Returns a Hash.
        def i18n_params
          {
            user_name: user_presenter.present,
            resource_name: present_resource,
            resource_id: resource_id
          }
        end

        # Private: Presents the resource of the action. If the resource is found
        # in the database, it links to it. Otherwise it only shows the resource name.
        #
        # Returns an HTML-safe String.
        def present_resource
          if resource
            h.link_to(resource_name, resource_path, class: "logs__log__resource")
          else
            h.content_tag(:span, resource_name, class: "logs__log__resource")
          end
        end

        # Private: Finds the public link for the given resource.
        #
        # Returns an HTML-safe String.
        def resource_path
          url_helpers.redirect_rules_path(anchor: "redirect-rule-#{resource_id}")
        end

        # Private: Presents resource name.
        #
        # Returns an HTML-safe String.
        def resource_name
          RedirectRule.model_name.human
        end
      end
    end
  end
end
