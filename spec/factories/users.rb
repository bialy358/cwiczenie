FactoryGirl.define do
  factory :user do
    email "user@spec.com"
    password "test1234"
    admin false
  end

  factory :admin, class: User do
    email "admin@spec.com"
    password "test1234"
    admin true
  end
end