# frozen_string_literal: true

module Decidim
  module UrlAliases
    # This is the engine that runs on the public interface of `DepartmentAdmin`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::UrlAliases::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        resources :redirect_rules, except: :show
      end

      initializer "decidim_admin.append_routes", before: :load_config_initializers do |_app|
        Rails.application.routes.append do
          mount Decidim::UrlAliases::AdminEngine => "/admin"
        end
      end

      initializer "decidim_admin.menu" do
        Decidim.menu :admin_menu do |menu|
          menu.item I18n.t("menu.url_aliases", scope: "decidim.url_aliases.admin"),
                    decidim_url_aliases_admin.redirect_rules_path,
                    icon_name: "wrench",
                    position: 14,
                    active: [%w(decidim/url_aliases/admin/redirect_rules), []],
                    if: allowed_to?(:update, :organization, organization: current_organization)
        end
      end

      def load_seed
        nil
      end
    end
  end
end
