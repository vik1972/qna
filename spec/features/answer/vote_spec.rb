# frozen_string_literal: true

require 'rails_helper'

feature "User can vote for a answer", "
  In order to note that answer is good
  As an authenticated user
  I would like to be able to vote
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'User is not an author of answer', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'votes up for answer' do
      within "#answer_#{answer.id}" do
        click_on 'Like'

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'tries to vote up for answer twice' do
      within "#answer_#{answer.id}" do
        click_on 'Like'
        click_on 'Like'

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'votes down for answer' do
      within "#answer_#{answer.id}" do
        click_on "Don't like"

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'tries to vote down for answer twice' do
      within "#answer_#{answer.id}" do
        click_on "Don't like"
        click_on "Don't like"

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'cancels his vote' do
      within "#answer_#{answer.id}" do
        click_on 'Like'
        click_on 'Cancel vote'

        within '.rating' do
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'can re-votes' do
      within "#answer_#{answer.id}" do
        click_on 'Like'
        click_on 'Cancel vote'
        click_on "Don't like"

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end
  end

  describe 'User is author of answer tries to', js: true do
    background do
      sign_in author
      visit question_path(question)
    end

    scenario 'vote up for his answer' do
      expect(page).to_not have_selector '.vote'
    end

    scenario 'vote down for his answer' do
      expect(page).to_not have_selector '.vote'
    end

    scenario 'cancel vote' do
      expect(page).to_not have_selector '.vote'
    end
  end

  describe 'Unauthorized user tries to vote' do
    background { visit question_path(question) }

    scenario 'vote up for answer' do
      expect(page).to_not have_selector '.vote'
    end

    scenario 'vote down for answer' do
      expect(page).to_not have_selector '.vote'
    end

    scenario 'cancel vote' do
      expect(page).to_not have_selector '.vote'
    end
  end
end
