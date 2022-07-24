# frozen_string_literal: true

require 'rails_helper'

feature 'User can his question', "
  In order to correct mistake
  As an author of question
  I'd like to able to edit my question
" do
  given(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:url) { 'https://google.ru' }

  describe 'Author of question', js: true do
    background do
      sign_in(author)
      visit questions_path
    end

    scenario 'edits his question' do
      within '.questions' do
        click_on 'Edit question'
        fill_in 'Title', with: 'edited question title'
        fill_in 'Body', with: 'edited question body'
        click_on 'Save'
      end
      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question title'
      expect(page).to_not have_selector 'text'
    end

    scenario 'can add attached files' do
      expect(page).to_not have_link 'rails_helper.rb'
      expect(page).to_not have_link 'spec_helper.rb'

      within '.questions' do
        click_on 'Edit question'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'add link to edited question' do
      within '.questions' do
        click_on 'Edit question'

        click_on 'add link'

        fill_in 'Link name', with: 'New_Link'
        fill_in 'Url', with: url

        click_on 'Save'
      end
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
    expect(page).to_not have_link 'Edit question'
  end
  scenario 'Unauthenticated user can not edit question' do
    visit questions_path
    expect(page).to_not have_link 'Edit question'
  end
end
