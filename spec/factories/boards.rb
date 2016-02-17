FactoryGirl.define do

  sequence(:name) { |n| "example#{n}" }

  factory :board do
    name
  end
end
