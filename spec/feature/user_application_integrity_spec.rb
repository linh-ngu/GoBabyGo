require "rails_helper"

RSpec.describe 'NO ACCOUNT: Attempt to access all user application pages', type: :feature do
    include Devise::Test::IntegrationHelpers
    before do
        @user_application = UserApplication.create(id: 1, child_first_name: "test", child_last_name: "child", child_birthdate: "2022-12-12", primary_diagnosis: "Can't walk", secondary_diagnosis: "N/A", child_height: 20, child_weight: 10, caregiver_email:"test@gmail.com", caregiver_first_name:"test", caregiver_last_name:"test", caregiver_phone:"1234567890",can_transport:true, can_store:true) 
    end
    scenario 'Index' do
        visit user_applications_path
        expect(page).to have_content("You do not have permission to view that page!")
    end

    scenario 'Show' do
        visit user_application_path(1)
        expect(page).to have_content("You do not have permission to view that page!")
    end

    scenario 'Edit' do
        visit edit_user_application_path(1)
        expect(page).to have_content("You do not have permission to view that page!")
    end

    scenario 'Delete' do
        visit delete_user_application_path(1)
        expect(page).to have_content("You do not have permission to view that page!")
    end
end

RSpec.describe 'VISITOR: Attempt to access user application pages that do not belong to the user.', type: :feature do
    include Devise::Test::IntegrationHelpers
    before do
        @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
        sign_in @admin
        @user = User.create!(email: 'test@gmail.com', first_name: "Test", last_name: "User", phone: '1234567890', admin_id: @admin.id, level: :visitor)
        @user_application = UserApplication.create(id: 2, user_id: 2, child_first_name: "test", child_last_name: "child", child_birthdate: "2022-12-12", primary_diagnosis: "Can't walk", secondary_diagnosis: "N/A", child_height: 20, child_weight: 10, caregiver_email:"test@gmail.com", caregiver_first_name:"test", caregiver_last_name:"test", caregiver_phone:"1234567890",can_transport:true, can_store:true) 
    end

    scenario 'Show' do
        visit user_application_path(2)
        expect(page).to have_content("You do not have permission to view that page!")
    end

    scenario 'Edit' do
        visit edit_user_application_path(2)
        expect(page).to have_content("You do not have permission to view that page!")
    end

    scenario 'Delete' do
        visit delete_user_application_path(2)
        expect(page).to have_content("You do not have permission to view that page!")
    end
end

RSpec.describe 'APPLICANT: Attempt to access usre application pages that do not belong to the user.', type: :feature do
    include Devise::Test::IntegrationHelpers
    before do
        @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
        sign_in @admin
        @user = User.create!(email: 'test@gmail.com', first_name: "Test", last_name: "User", phone: '1234567890', admin_id: @admin.id, level: :applicant)
        @user_application = UserApplication.create(id: 2, user_id: 2, child_first_name: "test", child_last_name: "child", child_birthdate: "2022-12-12", primary_diagnosis: "Can't walk", secondary_diagnosis: "N/A", child_height: 20, child_weight: 10, caregiver_email:"test@gmail.com", caregiver_first_name:"test", caregiver_last_name:"test", caregiver_phone:"1234567890",can_transport:true, can_store:true) 
    end

    scenario 'Show' do
        visit user_application_path(2)
        expect(page).to have_content("You do not have permission to view that page!")
    end

    scenario 'Edit' do
        visit edit_user_application_path(2)
        expect(page).to have_content("You do not have permission to view that page!")
    end

    scenario 'Delete' do
        visit delete_user_application_path(2)
        expect(page).to have_content("You do not have permission to view that page!")
    end
end