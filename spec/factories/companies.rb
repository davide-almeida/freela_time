FactoryBot.define do
  factory :company do
    name {Faker::Company.name}
    description {Faker::Company.catch_phrase}
    user
  end
end
