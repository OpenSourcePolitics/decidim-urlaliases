# frozen_string_literal: true

require "spec_helper"

describe Decidim::UrlAliases::Admin::DestroyRedirectRule do
  subject { described_class.new(rule, user) }

  let!(:rule) { create(:redirect_rule) }
  let(:user) { create(:user, :admin, :confirmed, organization: rule.organization) }

  context "when everything is ok" do
    it "broadcasts ok" do
      expect { subject.call }.to broadcast(:ok)
    end

    it "destroys the redirect rule" do
      expect { subject.call }.to change(RedirectRule, :count).by(-1)
    end

    it "traces the action", versioning: true do
      expect(Decidim.traceability)
        .to receive(:perform_action!)
        .with(:delete, rule, user)
        .and_call_original

      expect { subject.call }.to change(Decidim::ActionLog, :count)
      action_log = Decidim::ActionLog.last
      expect(action_log.version).to be_present
    end
  end

  context "when the redirect rule is not destroyed" do
    before { allow(rule).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed) }

    it "broadcasts invalid" do
      expect { subject.call }.to broadcast(:invalid)
    end
  end
end
