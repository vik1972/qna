require 'rails_helper'

feature 'User can create answer', %q{
  In order to create answer
  As an authenticated user
  I'd like to be able create answer
}do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }


  describe 'Authenticated user', js: true  do
    background do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'can create answer' do
      fill_in 'Your answer', with: 'Answer text'
      click_on 'New answer'

      within '.answers' do
        expect(page).to have_content 'Answer text'
      end
    end

    scenario 'can create answer with invalid data' do
      click_on 'New answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Unauthenticated user can't create answer" do
    visit question_path(question)

    expect(page).to_not have_content "New answer"
  end

end