require 'rails_helper'

feature 'User can his question', %q{
  In order to correct mistake
  As an author of question
  I'd like to able to edit my question
}do
  given(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'Author of question', js: true do
    background do
      sign_in(author)
      visit questions_path
    end

    scenario 'edits his question' do
      # save_and_open_page
      within '.questions' do
        click_on 'Edit question'
        fill_in 'Title', with: 'edited question title'
        fill_in 'Body', with: 'edited question body'
        click_on 'Save'
      end
      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question title'
      expect(page).to_not have_selector 'textarea'
    end

    scenario 'edits his question with invalid' do
      within '.questions' do
        click_on 'Edit question'
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'
      end
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
      expect(page).to have_selector 'textarea'
    end

  end

  scenario "Authenticated user tries to edit other user's question" do
    sign_in(user)
    visit questions_path
    expect(page).to_not have_link "Edit question"
  end
  scenario "Unauthenticated user can not edit question" do
    visit questions_path
    expect(page).to_not have_link "Edit question"
  end
end