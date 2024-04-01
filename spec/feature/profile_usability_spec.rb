# location spec/feature/profile_usability_spec.rb
require "rails_helper"

RSpec.describe 'APPLICANT: Routing from the dashboard to edit profile page.', type: :feature do
    include Devise::Test::IntegrationHelpers

    before do
        @admin = Admin.create!(
            email: 'test@gmail.com', 
            full_name: 'Test Admin', 
            uid: '123456', 
            avatar_url: 'http://example.com/avatar', 
            user_account_created: true
        )
        sign_in @admin
        @user = User.create!(
            email: 'test@gmail.com', 
            first_name: "Test", 
            last_name: "User", 
            phone: '1234567890', 
            admin_id: @admin.id, 
            level: :applicant
        )
    end

    scenario 'SUNNY: Start at the dashboard. Route to the edit profile page and back.' do
        visit dashboard_path
        expect(page).to have_content(@user.email)
        expect(page).to have_content(@user.phone)
        click_on "Edit Your Profile"
        click_on "Back to Dashboard"
        expect(page).to have_content(@user.email)
        expect(page).to have_content(@user.phone)
    end
end

RSpec.describe 'Visitor: Routing from the dashboard to edit profile page.', type: :feature do
    include Devise::Test::IntegrationHelpers

    before do
        @admin = Admin.create!(
            email: 'test@gmail.com', 
            full_name: 'Test Admin', 
            uid: '123456', 
            avatar_url: 'http://example.com/avatar', 
            user_account_created: true
        )
        sign_in @admin
        @user = User.create!(
            email: 'test@gmail.com', 
            first_name: "Test", 
            last_name: "User", 
            phone: '1234567890', 
            admin_id: @admin.id, 
            level: :visitor
        )
    end

    scenario 'SUNNY: Start at the dashboard. Route to the edit profile page and back.' do
        visit dashboard_path
        expect(page).to have_content(@user.email)
        expect(page).to have_content(@user.phone)
        click_on "Edit Your Profile"
        click_on "Back to Dashboard"
        expect(page).to have_content(@user.email)
        expect(page).to have_content(@user.phone)
    end
end