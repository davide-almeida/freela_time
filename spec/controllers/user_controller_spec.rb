# require 'rails_helper'

# # RSpec.describe UserController, type: :controller do

# # end

# RSpec.describe App::UsersController, type: :controller do

#   context 'Not authorized' do
#     describe "GET /edit" do
#       it 'responds a 302 response (not authorized)' do
#         user = create(:user)
#         get :edit, params: { id: user.id }
#         expect(response).to have_http_status(302)
#       end
#     end
#   end

#   context 'Authorized' do
#     describe "Sign_in" do
#       it "Sign_in User - response 200" do
#         user = create(:user)
#         sign_in user
#         get :edit, params: { id: user.id }
#         expect(response).to have_http_status(200)
#       end
#     end
#   end

# end