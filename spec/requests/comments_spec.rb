require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  
  before do
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end

  describe "POST /projects/:project_id/comments" do
    let(:valid_attributes) { { comment: { content: "This is a test comment" } } }
    let(:invalid_attributes) { { comment: { content: "" } } }
    
    context "with valid parameters" do
      it "creates a new comment" do
        expect {
          post project_comments_path(project), params: valid_attributes
        }.to change(Comment, :count).by(1)
      end

      it "creates a new conversation entry" do
        expect {
          post project_comments_path(project), params: valid_attributes
        }.to change(ConversationEntry, :count).by(1)
      end
      
      it "redirects to the project page" do
        post project_comments_path(project), params: valid_attributes
        expect(response).to redirect_to(project_path(project))
      end
      
      it "uses the Comments::CreateService" do
        service_double = instance_double(Comments::CreateService, call: Comment.new)
        expect(Comments::CreateService).to receive(:call).with(
          user: user,
          project: project,
          params: ActionController::Parameters.new(valid_attributes[:comment]).permit(:content)
        ).and_return(service_double.call)
        
        post project_comments_path(project), params: valid_attributes
      end
    end

    context "with invalid parameters" do
      it "does not create a new comment" do
        expect {
          post project_comments_path(project), params: invalid_attributes
        }.not_to change(Comment, :count)
      end

      it "does not create a new conversation entry" do
        expect {
          post project_comments_path(project), params: invalid_attributes
        }.not_to change(ConversationEntry, :count)
      end

      it "returns unprocessable entity status" do
        post project_comments_path(project), params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  
  context "with turbo_stream format" do
    it "responds with turbo_stream format when requested" do
      post project_comments_path(project), 
           params: { comment: { content: "Test comment" } }, 
           headers: { "Accept" => "text/vnd.turbo-stream.html" }
           
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    end
    
    it "renders the correct turbo_stream template" do
      post project_comments_path(project), 
           params: { comment: { content: "Test comment" } }, 
           headers: { "Accept" => "text/vnd.turbo-stream.html" }
           
      expect(response.body).to include('turbo-stream')
      expect(response.body).to include('conversation_entries')
    end
  end
end
