require 'rails_helper'

RSpec.describe User, type: :model do
  context 'Validations' do
    it 'is valid with first_name, last_name, email and password' do
      user = create(:user)
      expect(user).to be_valid
    end

    it 'is invalid without last_name' do
      user = build(:user, last_name: nil) #cria apenas na memória, não cadastra de fato.
      expect(user).to_not be_valid
    end

  end
end
