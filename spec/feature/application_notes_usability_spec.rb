# location spec/feature/application_notes_usability_spec.rb
require "rails_helper"

RSpec.describe 'STAFF MEMBER: Routing from the dashboard to different application notes pages.', type: :feature do
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
            level: :staff_member
        )
        @user_application = UserApplication.create(
            child_first_name: "test", 
            child_last_name: "child", 
            child_birthdate: "2022-12-12", 
            primary_diagnosis: "Can't walk", 
            secondary_diagnosis: "N/A", 
            child_height: 20, 
            child_weight: 10, 
            caregiver_email: "test@gmail.com", 
            caregiver_first_name: "test", 
            caregiver_last_name: "caregiver", 
            caregiver_phone: "1234567890",
            can_transport:true, 
            can_store:true,
            user_id: @user.id
        ) 
        @application_note = ApplicationNote.create(
            user_application_id: @user_application.id, 
            content: "Test Note", 
            created_at: Time.now, 
            updated_at: Time.now, 
            creator_id: @user.id
        )
    end

    scenario 'SUNNY: Start at the dashboard. Route to the application notes page and back.' do
        visit dashboard_path
        click_on "View User Applications"
        click_on "View"
        click_on "test child's Notes"
        click_on "Back to test child's Application"
        click_on "Back to Applications"
        click_on "Back to Dashboard"
    end

    scenario 'SUNNY: Start at the application notes page and start to delete a note, then cancel. Then, go back and delete it for sure.' do
        visit user_application_application_notes_path(@user_application)
        expect(page).to have_content("Test Note")
        click_on 'View'
        click_on 'Delete note'
        expect(page).to have_content("Are you sure you want to permanently delete this note?")
        click_on "Back to test child's Notes"
        expect(page).to have_content("Test Note")
        click_on 'View'
        click_on 'Delete note'
        expect(page).to have_content("Are you sure you want to permanently delete this note?")
        application_notes_count_before_deletion = ApplicationNote.count
        click_on "Delete application note"
        expect(ApplicationNote.count).to eq(application_notes_count_before_deletion - 1)
        expect(ApplicationNote.exists?(@application_note.id)).to be_falsey
    end

    scenario 'SUNNY: Start at the application notes page and start to edit a note, then cancel. Then, go back and edit it for sure.' do
        visit user_application_application_notes_path(@user_application)
        expect(page).to have_content("Test Note")
        click_on 'Edit'
        expect(page).to have_content("Editing application note")
        fill_in 'application_note_content', with: 'New Note'
        click_on "Back to test child's Notes"
        expect(page).to have_content("Test Note")
        click_on 'Edit'
        fill_in 'application_note_content', with: 'New Note'
        click_on "Update test child's Note"
        expect(page).to have_content('Application note was successfully updated.')
        expect(page).to have_content('New Note')
        expect(@application_note.reload.content).to eq('New Note')
    end
end