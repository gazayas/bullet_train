FactoryBot.define do
  factory :order do
    association :agreement
    title { "MyString" }
  end
end
