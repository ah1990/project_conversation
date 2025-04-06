FactoryBot.define do
  factory :status_change do
    from_status { "created" }
    to_status { "in_progress" }
    reason { "Starting work on the project" }
    association :user
    association :project
  end
end
