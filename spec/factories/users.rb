FactoryGirl.define do
  sequence :email do |n|
    "test#{n}@example.com"
  end
  factory :user do
    email
    password 'test1234'
    admin false
  end

  factory :admin, class: User do
    email
    password 'test1234'
    admin true
  end
end