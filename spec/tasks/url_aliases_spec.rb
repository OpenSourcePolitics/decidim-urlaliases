# frozen_string_literal: true

require "spec_helper"
require "rake"

describe "url_aliases" do
  describe "generate:reserved_paths" do
    let(:task) { "url_aliases:generate:reserved_paths" }
    let(:invoke_task) { Rake.application.invoke_task(task) }

    before do
      Rake.application.rake_require "tasks/url_aliases"
      Rake::Task.define_task(:environment)
      allow(STDOUT).to receive(:puts)
      allow(File).to receive(:write)
    end

    it "creates a YAML file with reserved_paths in it" do
      expect(File).to receive(:write).with(
        # rubocop:disable Style/RegexpLiteral
        /config\/url_aliases\/reserved_paths.yml/,
        # rubocop:enable Style/RegexpLiteral
        Regexp.union(/.+core_paths:/, /.*verifications_paths:/, /.*space_index_paths:.+/)
      )

      invoke_task
    end
  end
end
