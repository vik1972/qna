# frozen_string_literal: true

require 'rails_helper'

feature "User can vote for a question", "
  In order to note that question is good
  As an authenticated user
  I would like to be able to vote
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'User is not an author of question', js: true do
    background do
      sign_in user
      visit questions_path
    end

    scenario 'votes up for question' do
      within "#question-#{question.id}" do
        click_on 'Like'

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'tries to vote up for question twice' do
      within "#question-#{question.id}" do
        click_on 'Like'
        click_on 'Like'

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'votes down for question' do
      within "#question-#{question.id}" do
        click_on "Don't like"

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'tries to vote down for question twice' do
      within "#question-#{question.id}" do
        click_on "Don't like"
        click_on "Don't like"

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'cancels his vote' do
      within "#question-#{question.id}" do
        click_on 'Like'
        click_on 'Cancel vote'

        within '.rating' do
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'can re-votes' do
      within "#question-#{question.id}" do
        click_on 'Like'
        click_on 'Cancel vote'
        click_on "Don't like"

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end
  end
  describe 'User is author of question tries to', js: true do
    background do
      sign_in author
      visit questions_path
    end

    scenario 'vote up for his question' do
      expect(page).to_not have_selector '.vote'
    end

    scenario 'vote down for his question' do
      expect(page).to_not have_selector '.vote'
    end

    scenario 'cancel vote' do
      expect(page).to_not have_selector '.vote'
    end
  end

  describe 'Unauthorized user tries to vote' do
    background { visit questions_path }

    scenario 'vote up for question' do
      expect(page).to_not have_selector '.vote'
    end

    scenario "vote down for question" do
      expect(page).to_not have_selector ".vote"
    end

    scenario "cancel vote" do
      expect(page).to_not have_selector ".vote"
    end
  end
end
