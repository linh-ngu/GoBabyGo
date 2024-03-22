# location spec/feature/application_notes_correctness_spec.rb
require 'rails_helper'

RSpec.describe 'Creating an application note', type: :feature do
    include Devise::Test::IntegrationHelpers

    before do
        @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
        sign_in @admin
        @user = User.create!(first_name: "test", last_name: "name", email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :staff_member)
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
    end

    scenario 'SUNNY: Create a note with valid inputs' do
        visit user_application_application_notes_path(@user_application)
        click_on 'New application note'
        fill_in 'application_note_content', with: 'Test Note'
        click_on 'Create Application note'
        expect(page).to have_text('Application note was successfully created.')
        @application_note = ApplicationNote.find_by(content: 'Test Note')
        expect(@application_note).to be_present
    end

    scenario 'RAINY: Create a note with blank inputs' do
        visit user_application_application_notes_path(@user_application)
        click_on 'New application note'
        fill_in 'application_note_content', with: ''
        click_on 'Create Application note'
        expect(page).to have_text("Content can't be blank")
    end
end

RSpec.describe 'Editing an application note', type: :feature do
    include Devise::Test::IntegrationHelpers

    before do
        @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
        sign_in @admin
        @user = User.create!(first_name: "test", last_name: "name", email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :staff_member)
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

    scenario 'SUNNY: Edit a note with valid inputs' do
        visit user_application_application_notes_path(@user_application)
        click_on 'Edit this application note'
        fill_in 'application_note_content', with: 'Edited Test Note'
        click_on 'Update Application note'
        expect(page).to have_text('Application note was successfully updated.')
        expect(@application_note.reload.content).to eq('Edited Test Note')
    end

    scenario 'RAINY: Edit a note with blank inputs' do
        visit user_application_application_notes_path(@user_application)
        click_on 'Edit this application note'
        fill_in 'application_note_content', with: ''
        click_on 'Update Application note'
        expect(page).to have_text("Content can't be blank")
    end
end

RSpec.describe 'Deleting an application note', type: :feature do
    include Devise::Test::IntegrationHelpers

    before do
        @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
        sign_in @admin
        @user = User.create!(first_name: "test", last_name: "name", email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :staff_member)
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

    scenario 'SUNNY: Delete a note' do
        visit user_application_application_notes_path(@user_application)
        click_on 'Show this application note'
        click_on 'Delete note'
        expect(page).to have_text('Are you sure you want to permanently delete this note?')
        click_on 'Delete application note'
        expect(page).to have_text('Application note was successfully destroyed.')
        expect(ApplicationNote.exists?(@application_note.id)).to be_falsey
    end
end