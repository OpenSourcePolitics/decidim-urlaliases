# frozen_string_literal: true

module Decidim
  module UrlAliases
    module Admin
      # The main application controller that inherits from Rails.
      class ApplicationController < Decidim::Admin::ApplicationController
        private

        def permission_class_chain
          [
            Decidim::UrlAliases::Admin::Permissions,
            Decidim::Admin::Permissions
          ]
        end
      end
    end
  end
end
