FactoryGirl.define do
  sequence(:user_id) { |n| "example#{n}" }
  sequence(:board_id) { |n| "example#{n}" }

  factory :member do
    user_id
    board_id
  end

end
