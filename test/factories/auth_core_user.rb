FactoryGirl.define do
    sequence(:email) do |n|
        "person#{n}@example.com"
    end

    factory :user, class: Brewery::AuthCore::User do
        email

        password { SecureRandom.hex(6) }
        password_confirmation { password }


        before(:create) do |user|
            user.class.maintain_sessions = false
        end

        after(:create) do |user, evaluator|
            user.has_role!(:user_role)
            user.class.maintain_sessions = true
        end

        factory :user_with_names do
            other_names 'John'
            family_name 'Doe'
        end

        factory :user_admin do
            after(:create) do |user, evaluator|
                user.has_role!(:admin_user)
                user.has_role!(:admin)
            end
        end

        factory :user_superadmin do
            after(:create) do |user, evaluator|
                user.has_role!(:superadmin)
                user.has_role!(:admin)
            end
        end
    end
end