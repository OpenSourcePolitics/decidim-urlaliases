# frozen_string_literal: true

require "spec_helper"

describe "Redirect rules", type: :system do
  let(:url_helpers) { Decidim::UrlAliases::AdminEngine.routes.url_helpers }
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization: organization) }
  let!(:rule) { create(:redirect_rule, organization: organization) }
  let!(:other_rule) { create(:redirect_rule) }

  before do
    switch_to_host(organization.host)
    sign_in user, scope: :user
    visit url_helpers.redirect_rules_path
  end

  it "shows the redirect rule table list" do
    within "#redirect_rules" do
      within ".card-title" do
        expect(page).to have_content("REDIRECT RULES")
        expect(page).to have_link("Add")
      end

      within "table thead" do
        expect(page).to have_content("ID")
        expect(page).to have_content("SOURCE")
        expect(page).to have_content("DESTINATION")
        expect(page).to have_content("SOURCE IS CASE SENSITIVE")
        expect(page).to have_content("ACTIVE")
      end
    end
  end

  it "lists only redirect rules from the organization" do
    within "#redirect_rules" do
      expect(page).not_to have_css("#redirect-rule-#{other_rule.id}")

      within "#redirect-rule-#{rule.id}" do
        expect(page).to have_content(rule.id)
        expect(page).to have_content(rule.source)
        expect(page).to have_content(rule.destination)
        expect(page).to have_content("no")
        expect(page).to have_content("yes")

        within ".table-list__actions" do
          expect(page).to have_link("Edit")
          expect(page).to have_link("Delete")
        end
      end
    end
  end

  context "when creating a redirect rule" do
    before { click_link("Add") }

    it "shows the empty form" do
      within "form.new_redirect_rule" do
        expect(page).to have_content("NEW REDIRECT RULE")
        expect(page).to have_field("Source", placeholder: "/my-custom-url")
        expect(page).to have_field("Source is case sensitive", checked: false)
        expect(page).to have_field("Destination", placeholder: "/processes/process-slug")
        expect(page).to have_field("Active", checked: false)
        expect(page).to have_button("Create")
      end
    end

    context "when the form is filled with invalid data" do
      before do
        fill_in :redirect_rule_source, with: "/admin"
        fill_in :redirect_rule_destination, with: "/invalid/url"
        click_button("Create")
      end

      it "does not create a redirect rule" do
        expect(page).to have_css(".callout.alert", text: "error")
        within "form.new_redirect_rule" do
          expect(page).to have_css(".form-error", text: "must not be a reserved keyword.")
          expect(page).to have_css(".form-error", text: "must be recognized by the application.")
        end
      end
    end

    context "when the form is filled with valid data" do
      before do
        fill_in :redirect_rule_source, with: "/my-custom-url"
        fill_in :redirect_rule_destination, with: "/processes/process-slug"
        click_button("Create")
      end

      it "creates a redirect rule" do
        expect(page).to have_css(".callout.success", text: "successfully")
      end
    end
  end

  context "when updating a redirect rule" do
    before { click_link("Edit") }

    it "shows the prefilled form" do
      within "form.edit_redirect_rule" do
        expect(page).to have_content("EDIT REDIRECT RULE")
        expect(page).to have_field("Source", with: rule.source)
        expect(page).to have_field("Source is case sensitive", checked: rule.source_is_case_sensitive)
        expect(page).to have_field("Destination", with: rule.destination)
        expect(page).to have_field("Active", checked: rule.active)
        expect(page).to have_button("Update")
      end
    end

    context "when the form is filled with invalid data" do
      before do
        fill_in :redirect_rule_source, with: rule.source.delete_prefix("/")
        click_button("Update")
      end

      it "does not update a redirect rule" do
        expect(page).to have_css(".callout.alert", text: "error")
        within "form.edit_redirect_rule" do
          expect(page).to have_css(".form-error", text: "must start with \"/\" and contain only letters, numbers, dashes and/or underscores.")
        end
      end
    end

    context "when the form is filled with valid data" do
      before do
        uncheck("Active")
        click_button("Update")
      end

      it "updates the redirect rule" do
        expect(page).to have_css(".callout.success", text: "successfully")
      end
    end
  end

  context "when deleting a redirect rule" do
    before { click_link("Delete") }

    it "is shown the confirm alert" do
      expect(accept_alert).to eq("Confirm delete")
    end

    it "deletes the redirect rule" do
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_css(".callout.success", text: "successfully")
    end
  end
end
