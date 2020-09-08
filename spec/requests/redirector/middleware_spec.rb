# frozen_string_literal: true

require "spec_helper"

describe "Redirector middleware", type: :request do
  let!(:rule) { create(:redirect_rule) }
  let!(:other_rule) { create(:redirect_rule) }

  before { host!(host) }

  context "when the request_host matches an organization's host" do
    let(:host) { rule.organization.host }

    it "redirects the visitor for a rule of the same organization" do
      get rule.source
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(rule.destination)
    end

    it "does NOT redirect the visitor for a rule of OTHER organization" do
      expect { get other_rule.source }.to raise_error(ActionController::RoutingError, /#{other_rule.source}/)
    end

    context "when another organization has the same rule" do
      let!(:other_rule) { create(:redirect_rule, source: rule.source) }

      it "redirects the visitor for a rule of the same organization" do
        get rule.source
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(rule.destination)
      end
    end
  end
end
