require 'rails_helper'

RSpec.describe "App::Friends", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/app/friends/index"
      expect(response).to have_http_status(:success)
    end
  end

end
