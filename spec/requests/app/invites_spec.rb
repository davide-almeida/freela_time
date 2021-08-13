require 'rails_helper'

RSpec.describe "App::Invites", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/app/invites/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/app/invites/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/app/invites/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
