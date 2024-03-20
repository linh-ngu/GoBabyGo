# location spec/feature/application_notes_integrity_spec.rb
require "rails_helper"

RSpec.describe 'NO ACCOUNT: Attempt to access application note pages', type: :feature do
    include Devise::Test::IntegrationHelpers

    before do
        @user_application = UserApplication.create(id: 1, user_id: 1, child_name: "test child", child_birthdate: "2022-12-12", primary_diagnosis: "Can't walk", secondary_diagnosis: "N/A", child_height: 20, child_weight: 10, caregiver_email:"test@gmail.com", caregiver_name:"test", caregiver_phone:"1234567890",can_transport:true, can_store:true)
        @application_note = ApplicationNote.create(id: 1, user_application_id: @user_application.id, content: "This is a test note.")
    end

    scenario 'Index' do
        visit user_application_application_notes_path(@user_application)
        expect(page).to have_content("You do not have permission to view that page!")
    end

    scenario 'Show' do
        visit user_application_application_note_path(@user_application, @application_note)
        expect(page).to have_content("You do not have permission to view that page!")
    end

    scenario 'Edit' do
        visit edit_user_application_application_note_path(@user_application, @application_note)
        expect(page).to have_content("You do not have permission to view that page!")
    end

    scenario 'Delete' do
        visit delete_user_application_application_note_path(@user_application, @application_note)
        expect(page).to have_content("You do not have permission to view that page!")
    end
end

RSpec.describe 'VISITOR: Attempt to access application note pages that do not belong to the user.', type: :feature do
    include Devise::Test::IntegrationHelpers
    before do
        @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar', user_account_created: true)
        sign_in @admin
        @user1 = User.create!(id: 1, email: 'test1@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :visitor)
        @user_application = UserApplication.create(id: 2, user_id: 2, child_name: "test child", child_birthdate: "2022-12-12", primary_diagnosis: "Can't walk", secondary_diagnosis: "N/A", child_height: 20, child_weight: 10, caregiver_email:"test@gmail.com", caregiver_name:"test", caregiver_phone:"1234567890",can_transport:true, can_store:true) 
        @application_note = ApplicationNote.create(id: 3, user_application_id: @user_application.id, content: "This is a test note.")
    end

    scenario 'Index' do
        visit user_application_application_notes_path(@user_application)
        expect(page).to have_content("You do not have permission to view that page!")
    end

    scenario 'Show' do
        visit user_application_application_note_path(@user_application, @application_note)
        expect(page).to have_content("You do not have permission to view that page!")
    end

    scenario 'Edit' do
        visit edit_user_application_application_note_path(@user_application, @application_note)
        expect(page).to have_content("You do not have permission to view that page!")
    end

    scenario 'Delete' do
        visit delete_user_application_application_note_path(@user_application, @application_note)
        expect(page).to have_content("You do not have permission to view that page!")
    end
end

RSpec.describe 'APPLICANT: Attempt to access application note pages that do not belong to the user.', type: :feature do
    include Devise::Test::IntegrationHelpers
    before do
        @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
        sign_in @admin
        @user1 = User.create!(id: 1, email: 'test1@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :applicant)
        @user_application = UserApplication.create(id: 2, user_id: 2, child_name: "test child", child_birthdate: "2022-12-12", primary_diagnosis: "Can't walk", secondary_diagnosis: "N/A", child_height: 20, child_weight: 10, caregiver_email:"test@gmail.com", caregiver_name:"test", caregiver_phone:"1234567890",can_transport:true, can_store:true) 
        @application_note = ApplicationNote.create(id: 3, user_application_id: @user_application.id, content: "This is a test note.")
    end

    scenario 'Index' do
        visit user_application_application_notes_path(@user_application)
        expect(page).to have_content("You do not have permission to view that page!")
    end

    scenario 'Show' do
        visit user_application_application_note_path(@user_application, @application_note)
        expect(page).to have_content("You do not have permission to view that page!")
    end

    scenario 'Edit' do
        visit edit_user_application_application_note_path(@user_application, @application_note)
        expect(page).to have_content("You do not have permission to view that page!")
    end

    scenario 'Delete' do
        visit delete_user_application_application_note_path(@user_application, @application_note)
        expect(page).to have_content("You do not have permission to view that page!")
    end
end