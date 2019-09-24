# frozen_string_literal: true

require "spec_helper"

describe Decidim::UrlAliases::Admin::RedirectRuleForm do
  subject { described_class.from_params(params).with_context(current_organization: rule.organization) }

  let(:rule) { create(:redirect_rule) }
  let(:source) { "/my-custom-url" }
  let(:destination) { "/processes/slug" }
  let(:params) do
    {
      "redirect_rule" => {
        "source" => source,
        "source_is_case_sensitive" => false,
        "destination" => destination,
        "active" => true
      }
    }
  end

  it { is_expected.to be_valid }

  describe "source validations" do
    context "without source" do
      let(:source) { nil }

      it { is_expected.to be_invalid }
    end

    context "when the source format is NOT valid" do
      let(:source) { "my-custom-url" }

      it { is_expected.to be_invalid }
    end

    context "when the source is a reserved_path" do
      let(:source) { "/admin" }

      it { is_expected.to be_invalid }
    end

    context "when the source has already been taken" do
      let(:source) { rule.source }

      it { is_expected.to be_invalid }
    end
  end

  describe "destination validations" do
    context "without destination" do
      let(:destination) { nil }

      it { is_expected.to be_invalid }
    end

    context "when the destination format is NOT valid" do
      let(:destination) { "processes" }

      it { is_expected.to be_invalid }
    end

    context "when the destination is not recognized" do
      let(:destination) { "/invalid/path" }

      it { is_expected.to be_invalid }
    end

    context "when the destination has already been taken" do
      let(:destination) { rule.destination }

      it { is_expected.to be_invalid }
    end
  end
end
