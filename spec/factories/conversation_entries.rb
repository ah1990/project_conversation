FactoryBot.define do
  factory :conversation_entry do
    association :project
    association :user
    created_at { Time.current }
    
    trait :for_comment do
      association :entryable, factory: :comment
    end
    
    trait :for_status_change do
      association :entryable, factory: :status_change
    end
  end
end
