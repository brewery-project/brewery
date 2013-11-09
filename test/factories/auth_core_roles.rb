FactoryGirl.define do
	factory :role, class: Brewery::AuthCore::Role do
        name 'Some Stupidly named role'
    end

    factory :superadmin_role, class: Brewery::AuthCore::Role do
        name 'superadmin'
        hidden false
    end

    factory :user_role, class: Brewery::AuthCore::Role do
        name 'user_role'
    end

    factory :admin_user_role, class: Brewery::AuthCore::Role do
        name 'admin_user'
    end
end