require 'rails_helper'

feature 'User can sing out', %q{
  In order to end the session
  As an authenticated user
  I'd like to be able to sign out
}do
  given(:user) { create(:user) }
  background do
    sign_in(user)
    visit questions_path
  end
  scenario 'Authenticated user tries to sing out' do
    click_on 'Log out'

    expect(page).to have_content "Signed out successfully."
  end
end