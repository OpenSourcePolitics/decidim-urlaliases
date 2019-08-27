# frozen_string_literal: true

module Decidim
  module UrlAliases
    module Admin
      class RedirectRuleForm < Form
        mimic :redirect_rule

        attribute :source, String
        attribute :source_is_case_sensitive, Boolean
        attribute :destination, String
        attribute :active, Boolean

        validates_presence_of :source, :destination
        validates :source, format: {
          with: RouteRecognizer::VALID_SOURCE_REGEX,
          message: I18n.t("decidim.url_aliases.format_error")
        }
        validate :source_uniqueness
        validate :source_must_not_be_reserved
        validate :destination_uniqueness
        validate :destination_must_be_recognized

        private

        def route_recognizer
          @route_recognizer ||= RouteRecognizer.new
        end

        def source_must_not_be_reserved
          return unless route_recognizer.reserved_path?(source)

          errors.add(:source, :reserved)
        end

        def destination_must_be_recognized
          return if route_recognizer.matching_path?(destination)

          errors.add(:destination, :not_recognized)
        end

        def organization_redirect_rules
          RedirectRule.where(organization: current_organization).where.not(id: id)
        end

        def source_uniqueness
          return unless organization_redirect_rules.where(source: source).any?

          errors.add(:source, :taken)
        end

        def destination_uniqueness
          return unless organization_redirect_rules.where(destination: destination).any?

          errors.add(:destination, :taken)
        end
      end
    end
  end
end
