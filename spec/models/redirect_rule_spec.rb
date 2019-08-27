# frozen_string_literal: true

require "spec_helper"

describe RedirectRule do
  subject { rule }

  let(:rule) { create(:redirect_rule) }

  it { is_expected.to be_valid }

  describe "validations" do
    context "without organization" do
      before { rule.organization = nil }

      it { is_expected.to be_invalid }
    end
  end

  describe "::log_presenter_class_for" do
    subject { RedirectRule.log_presenter_class_for(:admin_log) }

    it { is_expected.to be(Decidim::UrlAliases::AdminLog::RedirectRulePresenter) }
  end
end
