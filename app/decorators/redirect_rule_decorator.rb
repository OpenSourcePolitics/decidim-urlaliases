# frozen_string_literal: true

RedirectRule.class_eval do
  belongs_to :organization, foreign_key: :decidim_organization_id, class_name: "Decidim::Organization"

  validates :source, presence: true, uniqueness: { scope: :organization }
  validates :destination, presence: true, uniqueness: { scope: :organization }

  def self.match_sql_condition
    <<-SQL
      redirect_rules.active = :true AND
      ((source_is_regex = :false AND source_is_case_sensitive = :false AND LOWER(redirect_rules.source) = LOWER(:source)) OR
      (source_is_regex = :false AND source_is_case_sensitive = :true AND #{"BINARY" if connection_mysql?} redirect_rules.source = :source #{"COLLATE BINARY" if connection_sqlite?}) OR
      (source_is_regex = :true AND (#{regex_expression})))
    SQL
  end
end
