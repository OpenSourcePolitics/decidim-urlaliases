# frozen_string_literal: true

require "spec_helper"

describe "Redirector middleware", type: :feature do
  let!(:rule) { create(:redirect_rule) }
  let!(:other_rule) { create(:redirect_rule) }

  before { Capybara.app_host = "http://#{host}" }

  context "when the request_host matches an organization's host" do
    let(:host) { rule.organization.host }

    it "redirects the visitor for a rule of the same organization" do
      visit rule.source
      expect(page).to have_current_path(rule.destination)
    end

    it "does NOT redirect the visitor for a rule of OTHER organization" do
      expect { visit other_rule.source }.to raise_error(ActionController::RoutingError, /#{other_rule.source}/)
    end
  end
end
