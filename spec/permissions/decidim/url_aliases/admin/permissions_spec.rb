# frozen_string_literal: true

require "spec_helper"

describe Decidim::UrlAliases::Admin::Permissions do
  subject { described_class.new(user, permission_action, context).permissions.allowed? }

  let(:user) { create(:user, :admin) }
  let(:permission_action) do
    Decidim::PermissionAction.new(
      scope: action_scope,
      action: action_name,
      subject: action_subject
    )
  end
  let(:context) { {} }
  let(:action_scope) { :admin }
  let(:action_name) { nil }
  let(:action_subject) { :redirect_rule }

  context "when no user is given" do
    let(:user) { nil }

    it_behaves_like "permission is not set"
  end

  context "when the user is no admin" do
    before { user.admin = false }

    it_behaves_like "permission is not set"
  end

  context "when the scope is not admin" do
    let(:action_scope) { :public }

    it_behaves_like "permission is not set"
  end

  context "when subject is not redirect_rule" do
    let(:action_subject) { :foobar }

    it_behaves_like "permission is not set"
  end

  context "when action is not recognized" do
    let(:action_name) { :foobar }

    it_behaves_like "permission is not set"
  end

  describe "read action" do
    let(:action_name) { :read }

    it { is_expected.to be(true) }
  end

  describe "create action" do
    let(:action_name) { :create }

    it { is_expected.to be(true) }
  end

  shared_examples "without redirect_rule" do
    let(:context) { { redirect_rule: nil } }

    it_behaves_like "permission is not set"
  end

  shared_examples "with redirect_rule" do
    let(:context) { { redirect_rule: create(:redirect_rule, organization: user.organization) } }

    it { is_expected.to be(true) }
  end

  describe "update action" do
    let(:action_name) { :update }

    it_behaves_like "without redirect_rule"
    it_behaves_like "with redirect_rule"
  end

  describe "destroy action" do
    let(:action_name) { :update }

    it_behaves_like "without redirect_rule"
    it_behaves_like "with redirect_rule"
  end
end
