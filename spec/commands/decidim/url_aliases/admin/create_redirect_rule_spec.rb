# frozen_string_literal: true

require "spec_helper"

module Decidim::UrlAliases::Admin
  describe CreateRedirectRule do
    subject { described_class.new(form) }

    let(:user) { create(:user, :admin, :confirmed) }
    let(:form) { RedirectRuleForm.from_params(params).with_context(context) }
    let(:source) { "/my-custom-url" }
    let(:params) do
      {
        "redirect_rule" => {
          "source" => source,
          "source_is_case_sensitive" => false,
          "destination" => "/processes/slug",
          "active" => true
        }
      }
    end
    let(:context) do
      {
        current_user: user,
        current_organization: user.organization
      }
    end

    context "when the form is not valid" do
      let(:source) { nil }

      it "broadcasts invalid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when a redirect rule is not created" do
      before { allow(RedirectRule).to receive(:create!).and_raise(ActiveRecord::RecordInvalid) }

      it "broadcasts invalid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when everything is ok" do
      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "creates a redirect rule" do
        expect { subject.call }.to change(RedirectRule, :count).by(1)
      end

      it "traces the action", versioning: true do
        expect(Decidim.traceability)
          .to receive(:create!)
          .with(RedirectRule, user, kind_of(Hash))
          .and_call_original

        expect { subject.call }.to change(Decidim::ActionLog, :count)
        action_log = Decidim::ActionLog.last
        expect(action_log.version).to be_present
      end
    end
  end
end
