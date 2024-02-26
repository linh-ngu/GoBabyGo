# location spec/feature/applicant_profile_integration_spec.rb
require 'rails_helper'

RSpec.describe 'Edit Profile', type: :feature do
    include Devise::Test::IntegrationHelpers

    before do
        @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
        sign_in @admin
        @user = User.create!(email: 'linh.n565@gmail.com', phone: '1234567890', admin_id: @admin.id)
    end

    scenario 'valid inputs' do
        visit edit_user_path(@user)
        fill_in 'user_email', with: 'newemail@example.com'
        fill_in 'user_phone', with: '1234567890'
        click_on 'Update Profile'
        expect(page).to have_text('Profile was successfully updated.')
    end

    scenario 'blank inputs' do
        visit edit_user_path(@user)
        fill_in 'user_email', with: ''
        fill_in 'user_phone', with: ''
        click_on 'Update Profile'
        expect(page).to have_text("Email can't be blank, Phone can't be blank")
    end

    scenario 'invalid phone' do
        visit edit_user_path(@user)
        fill_in 'user_email', with: 'asdfadf@gmail.com'
        fill_in 'user_phone', with: '123456789'
        click_on 'Update Profile'
        expect(page).to have_text('Phone is the wrong length (should be 10 characters)')
    end
    
    scenario 'invalid email' do
        visit edit_user_path(@user)
        fill_in 'user_email', with: 'asdfadf'
        fill_in 'user_phone', with: '1234567890'
        click_on 'Update Profile'
        expect(page).to have_text('Email is invalid')
    end
end
