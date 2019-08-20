# frozen_string_literal: true

class AddOrganizationToRedirectRules < ActiveRecord::Migration[5.2]
  def change
    add_column :redirect_rules,
               :decidim_organization_id,
               :integer
  end
end
