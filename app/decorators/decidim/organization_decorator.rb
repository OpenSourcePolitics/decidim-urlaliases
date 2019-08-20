# frozen_string_literal: true

require_dependency "decidim/organization"

Decidim::Organization.class_eval do
  has_many :redirect_rules, foreign_key: :decidim_organization_id, class_name: "RedirectRule"
end
