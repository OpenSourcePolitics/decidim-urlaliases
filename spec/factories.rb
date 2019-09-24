# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :redirect_rule do
    active { true }
    source_is_regex { false }
    organization { create(:organization) }
    source { "/" + Faker::Internet.unique.slug }
    destination do
      component = create(:dummy_component, organization: organization)
      resource = create(:dummy_resource, component: component)
      Decidim::ResourceLocatorPresenter.new(resource).path
    end
  end
end
