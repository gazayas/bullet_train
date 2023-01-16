FactoryBot.define do
  factory :agreement do
    association :team
    title { "MyString" }
  end
end
