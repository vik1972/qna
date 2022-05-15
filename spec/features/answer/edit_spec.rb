require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated can not edit answer ' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true  do
    background do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'edits his answer' do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Your answer', with: 'edit answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edit answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Authenticated user tries to edit other user's answer" do
    sign_in(other_user)
    visit question_path(question)
    expect(page).to_not have_link "Edit"
  end
end