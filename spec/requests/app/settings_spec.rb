require 'rails_helper'

RSpec.describe "App::Settings", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/app/settings/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/app/settings/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/app/settings/new"
      expect(response).to have_http_status(:success)
    end
  end

end
