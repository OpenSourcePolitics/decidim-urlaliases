# frozen_string_literal: true

module Decidim
  module UrlAliases
    module Admin
      class RedirectRulesController < Decidim::UrlAliases::Admin::ApplicationController
        helper_method :redirect_rule, :organization_redirect_rules

        def index
          enforce_permission_to :read, :redirect_rule

          @redirect_rules = organization_redirect_rules
        end

        def new
          enforce_permission_to :create, :redirect_rule

          @form = form(RedirectRuleForm).instance
        end

        def create
          enforce_permission_to :create, :redirect_rule

          @form = form(RedirectRuleForm).from_params(params)

          CreateRedirectRule.call(@form) do
            on(:ok) do
              flash[:notice] = I18n.t("redirect_rules.create.success", scope: "decidim.url_aliases.admin")
              redirect_to redirect_rules_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("redirect_rules.create.error", scope: "decidim.url_aliases.admin")
              render :new
            end
          end
        end

        def edit
          enforce_permission_to :update, :redirect_rule, redirect_rule: redirect_rule

          @form = form(RedirectRuleForm).from_model(redirect_rule)
        end

        def update
          enforce_permission_to :update, :redirect_rule, redirect_rule: redirect_rule

          @form = form(RedirectRuleForm).from_params(params)

          UpdateRedirectRule.call(redirect_rule, @form) do
            on(:ok) do
              flash[:notice] = I18n.t("redirect_rules.update.success", scope: "decidim.url_aliases.admin")
              redirect_to redirect_rules_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("redirect_rules.update.error", scope: "decidim.url_aliases.admin")
              render :edit
            end
          end
        end

        def destroy
          enforce_permission_to :destroy, :redirect_rule, redirect_rule: redirect_rule

          DestroyRedirectRule.call(redirect_rule, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("redirect_rules.destroy.success", scope: "decidim.url_aliases.admin")
              redirect_to redirect_rules_path
            end

            on(:invalid) do
              flash[:alert] = I18n.t("redirect_rules.destroy.error", scope: "decidim.url_aliases.admin")
              redirect_to :index
            end
          end
        end

        private

        def redirect_rule
          @redirect_rule ||= organization_redirect_rules.find_by(id: params[:id])
        end

        def organization_redirect_rules
          RedirectRule.where(organization: current_organization)
        end
      end
    end
  end
end
