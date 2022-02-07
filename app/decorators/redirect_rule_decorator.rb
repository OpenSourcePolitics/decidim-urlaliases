# frozen_string_literal: true

# This decorator associates the model with a Decidim::Organization and adds a custom AdminLog presenter.
RedirectRule.class_eval do
  # Concern added.
  include Decidim::Traceable

  # Association added.
  belongs_to :organization, foreign_key: :decidim_organization_id, class_name: "Decidim::Organization"

  # Method added.
  # Sets the presenter class for the :admin_log for a RedirectRule resource.
  def self.log_presenter_class_for(_log)
    Decidim::UrlAliases::AdminLog::RedirectRulePresenter
  end
end
