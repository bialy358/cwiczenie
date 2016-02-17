FactoryGirl.define do
  sequence :name do |n|
    "example#{n}"
  end
  factory :board do
    name
  end
end
