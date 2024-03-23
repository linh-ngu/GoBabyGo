# location spec/feature/application_notes_usability_spec.rb
require "rails_helper"

RSpec.describe 'APPLICANT: Routing from the dashboard to different application notes pages.', type: :feature do
    include Devise::Test::IntegrationHelpers
    
    before do
        @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar', user_account_created: true)
        sign_in @admin
        @user = User.create!(first_name: "test", last_name: "name", email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :officer_member)
        @user_application = UserApplication.create(
            user_id: @user.id, 
            child_first_name: "test",
            child_last_name: "child",
            child_birthdate: "2024-02-08", 
            primary_diagnosis: "Can't walk", 
            secondary_diagnosis: "N/A", 
            child_height: 20, 
            child_weight: 10, 
            caregiver_first_name: "test",
            caregiver_last_name: "caregiver",
            caregiver_email: "test@gmail.com", 
            caregiver_phone: 1234567890,
            can_transport: true,
            can_store: true,
            notes: "N/A"
        )
        @application_note = ApplicationNote.create(user_application_id: @user_application.id, content: "Test Note")
    end

    scenario 'SUNNY: Start at the dashboard. Route to the application notes page and back.' do
        visit dashboard_path
        click_on "View User Applications"
        click_on "View"
        click_on "Notes"
        click_on "Back to Application"
        click_on "Back to Applications"
        click_on "Back to Dashboard"
    end

    scenario 'SUNNY: Start at the application notes page and start to delete a note, then cancel. Then, go back and delete it for sure.' do
        visit user_application_application_notes_path(@user_application)
        expect(page).to have_content("Test Note")
        click_on 'Show this application note'
        click_on 'Delete note'
        expect(page).to have_content("Are you sure you want to permanently delete this note?")
        click_on "Back to application note"
        click_on "Back to notes"
        expect(page).to have_content("Test Note")
        click_on 'Show this application note'
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
        click_on 'Edit this application note'
        expect(page).to have_content("Editing application note")
        fill_in 'application_note_content', with: 'New Note'
        click_on 'Back to application notes'
        expect(page).to have_content("Test Note")
        click_on 'Edit this application note'
        fill_in 'application_note_content', with: 'New Note'
        click_on 'Update Application note'
        expect(page).to have_content('Application note was successfully updated.')
        expect(page).to have_content('New Note')
        expect(@application_note.reload.content).to eq('New Note')
    end
end