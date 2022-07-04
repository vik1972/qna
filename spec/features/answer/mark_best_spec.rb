# frozen_string_literal: true

require 'rails_helper'

feature 'Mark as  best answer', "
  In order to choose answer that is the best
  As an authenticated user
  I'd like to be able to mark the answer as the best for my question
", js: true do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  scenario 'Unauthenticated user choose answer that is the best' do
    visit question_path(question)
    expect(page).to_not have_link 'Mark as best'
  end

  describe 'Authenticate user' do

    scenario 'as author can mark the answer as the best for my question' do
      sign_in(author)
      visit question_path(answer.question)

      within "#answer-#{answer.id}" do
        expect(page).to_not have_content 'Best answer:'
        click_on 'Mark as best'
        # save_and_open_page
        expect(page).to have_content 'Best answer:'
      end
      # expect(page).to have_content 'Best answer:'
    end

    scenario "can't mark the answer as the best for other question" do
      sign_in(user)
      visit question_path(answer.question)
      expect(page).to_not have_link 'Mark as best'
    end
  end
end
