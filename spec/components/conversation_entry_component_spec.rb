# frozen_string_literal: true

require "rails_helper"
require "view_component/test_helpers"

RSpec.describe ConversationEntryComponent, type: :component do
  include ViewComponent::TestHelpers
  let(:user) { create(:user, email: 'test@example.com', name: 'Test User') }
  let(:project) { create(:project) }
  
  describe "with a comment entry" do
    let(:comment) { create(:comment, user: user, project: project, content: "This is a test comment") }
    let(:entry) { create(:conversation_entry, user: user, project: project, entryable: comment) }
    let(:component) { described_class.new(entry: entry) }
    
    it "renders the comment content" do
      result = render_inline(component)
      expect(result.text).to include("This is a test comment")
    end
    
    it "displays the user name" do
      result = render_inline(component)
      expect(result.text).to include("Test User")
    end
    
    it "displays the user initial" do
      result = render_inline(component)
      expect(result.text).to include("T")
    end
    
    it "displays the time ago" do
      result = render_inline(component)
      expect(result.text).to match(/ago/)
    end
    
    it "identifies as a comment" do
      expect(component.comment?).to be true
      expect(component.status_change?).to be false
    end
  end
  
  describe "with a status change entry" do
    let(:status_change) { create(:status_change, user: user, project: project, from_status: "created", to_status: "in_progress", reason: "Starting work") }
    let(:entry) { create(:conversation_entry, user: user, project: project, entryable: status_change) }
    let(:component) { described_class.new(entry: entry) }
    
    it "renders the status change information" do
      result = render_inline(component)
      expect(result.text).to include("Changed status from Created to In Progress")
    end
    
    it "displays the reason for status change" do
      result = render_inline(component)
      expect(result.text).to include("Reason: Starting work")
    end
    
    it "displays a status change badge" do
      result = render_inline(component)
      expect(result.text).to include("Status Change")
    end
    
    it "identifies as a status change" do
      expect(component.comment?).to be false
      expect(component.status_change?).to be true
    end
    
    it "returns the correct from_status and to_status" do
      expect(component.from_status).to eq("Created")
      expect(component.to_status).to eq("In Progress")
    end
  end
end
