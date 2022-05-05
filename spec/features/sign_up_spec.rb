require 'rails_helper'

feature 'Guest can sign up', %q{
  In order to to create questions and answers
  As an unauthenticated user
  I'd like tobe able to sign up
}do
  given(:user) { create(:user) }
  background { visit new_user_registration_path }

  scenario 'Guest tries to sign up' do
    fill_in 'Email', with: 'bvv33@yandex.ru' # user.email #
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Guest tries to sign up with invalid data' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: ' '
    click_on 'Sign up'

    expect(page).to have_content 'prohibited this user from being saved'
  end

end