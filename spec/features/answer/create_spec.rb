require 'rails_helper'

feature 'User can create answer', %q{
  In order to create answer
  As an user
  I'd like to be able create answer
}do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  background { visit question_path(question) }

  scenario 'User can create answer' do
    fill_in 'Body', with: 'Answer text'
    click_on 'New answer'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'Answer text'
  end

  scenario 'User can create wrong answer' do
    click_on 'New answer'

    expect(page).to have_content "Body can't be blank"
  end
  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User can create answer' do
      fill_in 'Body', with: 'Answer text'
      click_on 'New answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Answer text'
    end
  end

end