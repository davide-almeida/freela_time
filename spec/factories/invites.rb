FactoryBot.define do
  factory :invite do
    user { nil }
    email { "MyString" }
    link { "MyString" }
    due_date { "2021-08-11" }
    status { 1 }
    invite_type { 1 }
  end
end
