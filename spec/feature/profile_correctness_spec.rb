# location spec/feature/profile_correctness_spec.rb
require 'rails_helper'

RSpec.describe 'APPLICANT: Edit Profile', type: :feature do
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

    scenario 'SUNNY: visit edit user path, update profile with valid inputs' do
        visit edit_user_path(@user)
        fill_in 'user_email', with: 'newemail@example.com'
        fill_in 'user_phone', with: '1234567890'
        click_on 'Update Profile'
        expect(page).to have_text('Profile was successfully updated.')
        profile = User.find(@user.id)
        expect(profile.email).to eq('newemail@example.com')
        expect(profile.phone).to eq(1234567890)
    end

    scenario 'RAINY: visit edit user path, update profile with blank inputs' do
        visit edit_user_path(@user)
        fill_in 'user_email', with: ''
        fill_in 'user_phone', with: ''
        click_on 'Update Profile'
        expect(page).to have_text("Email can't be blank, Phone can't be blank")
        profile = User.find(@user.id)
        expect(profile.email).to eq('test@gmail.com')
        expect(profile.phone).to eq(1234567890)
    end

    scenario 'RAINY: visit edit user path, update profile with an invalid phone number' do
        visit edit_user_path(@user)
        fill_in 'user_email', with: 'newemail@example.com'
        fill_in 'user_phone', with: '123456789'
        click_on 'Update Profile'
        expect(page).to have_text('Phone is the wrong length (should be 10 characters)')
        profile = User.find(@user.id)
        expect(profile.email).to eq('test@gmail.com')
        expect(profile.phone).to eq(1234567890)
    end
    
    scenario 'RAINY: visit edit user path, update profile with an invalid email' do
        visit edit_user_path(@user)
        fill_in 'user_email', with: 'newemail'
        fill_in 'user_phone', with: '1234567890'
        click_on 'Update Profile'
        expect(page).to have_text('Email is invalid')
        profile = User.find(@user.id)
        expect(profile.email).to eq('test@gmail.com')
        expect(profile.phone).to eq(1234567890)
    end
end

RSpec.describe 'VISITOR: Edit Profile', type: :feature do
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

    scenario 'SUNNY: visit edit user path, update profile with valid inputs' do
        visit edit_user_path(@user)
        fill_in 'user_email', with: 'newemail@example.com'
        fill_in 'user_phone', with: '1234567890'
        click_on 'Update Profile'
        expect(page).to have_text('Profile was successfully updated.')
        profile = User.find(@user.id)
        expect(profile.email).to eq('newemail@example.com')
        expect(profile.phone).to eq(1234567890)
    end

    scenario 'RAINY: visit edit user path, update profile with blank inputs' do
        visit edit_user_path(@user)
        fill_in 'user_email', with: ''
        fill_in 'user_phone', with: ''
        click_on 'Update Profile'
        expect(page).to have_text("Email can't be blank, Phone can't be blank")
        profile = User.find(@user.id)
        expect(profile.email).to eq('test@gmail.com')
        expect(profile.phone).to eq(1234567890)
    end

    scenario 'RAINY: visit edit user path, update profile with an invalid phone number' do
        visit edit_user_path(@user)
        fill_in 'user_email', with: 'newemail@example.com'
        fill_in 'user_phone', with: '123456789'
        click_on 'Update Profile'
        expect(page).to have_text('Phone is the wrong length (should be 10 characters)')
        profile = User.find(@user.id)
        expect(profile.email).to eq('test@gmail.com')
        expect(profile.phone).to eq(1234567890)
    end
    
    scenario 'RAINY: visit edit user path, update profile with an invalid email' do
        visit edit_user_path(@user)
        fill_in 'user_email', with: 'newemail'
        fill_in 'user_phone', with: '1234567890'
        click_on 'Update Profile'
        expect(page).to have_text('Email is invalid')
        profile = User.find(@user.id)
        expect(profile.email).to eq('test@gmail.com')
        expect(profile.phone).to eq(1234567890)
    end
end