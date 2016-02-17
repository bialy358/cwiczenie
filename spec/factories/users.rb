FactoryGirl.define do
  sequence(:email) { |n| "test#{n}@example.com" }

  factory :user do
    email
    password 'test1234'

    trait :admin do
      admin true
    end
  end
end