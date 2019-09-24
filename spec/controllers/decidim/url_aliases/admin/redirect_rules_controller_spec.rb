# frozen_string_literal: true

require "spec_helper"

describe Decidim::UrlAliases::Admin::RedirectRulesController, type: :controller do
  routes { Decidim::UrlAliases::AdminEngine.routes }

  let(:organization) { create(:organization) }
  let(:other_organization) { create(:organization) }
  let(:user) { create(:user, :confirmed, :admin, organization: organization) }

  let(:params) do
    {
      "redirect_rule" => {
        "source" => "/my-custom-url",
        "source_is_case_sensitive" => false,
        "destination" => "/processes/slug",
        "active" => true
      }
    }
  end

  before do
    request.env["decidim.current_organization"] = organization
    sign_in user, scope: :user
  end

  describe "GET index" do
    before do
      create_list(:redirect_rule, 10, organization: organization)
      create_list(:redirect_rule, 10, organization: other_organization)
    end

    it "renders the index listing" do
      get :index

      expect(response).to have_http_status(:ok)
      expect(subject).to render_template(:index)
      expect(assigns(:redirect_rules).count).to eq(10)
    end
  end

  describe "GET new" do
    it "renders the empty form" do
      get :new

      expect(response).to have_http_status(:ok)
      expect(subject).to render_template(:new)
    end
  end

  describe "POST create" do
    it "creates a redirect rule" do
      post :create, params: params

      expect(flash[:notice]).not_to be_empty
      expect(response).to have_http_status(:found)
      expect(subject).to redirect_to(action: :index)
    end
  end

  describe "GET edit" do
    let(:rule) { create(:redirect_rule, organization: organization) }

    it "renders the edit form" do
      get :edit, params: { id: rule.id }

      expect(response).to have_http_status(:ok)
      expect(subject).to render_template(:edit)
    end
  end

  describe "PUT update" do
    let(:rule) { create(:redirect_rule, organization: organization) }

    it "updates the redirect rule" do
      put :update, params: params.merge(id: rule.id)

      expect(flash[:notice]).not_to be_empty
      expect(response).to have_http_status(:found)
      expect(subject).to redirect_to(action: :index)
    end
  end

  describe "DELETE destroy" do
    let(:rule) { create(:redirect_rule, organization: organization) }

    it "destroys the redirect rule" do
      delete :destroy, params: { id: rule.id }

      expect(flash[:notice]).not_to be_empty
      expect(response).to have_http_status(:found)
      expect(subject).to redirect_to(action: :index)
    end
  end
end
