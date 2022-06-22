require 'rails_helper'

feature "User can see new comment to question or answer", "
  In order to get a comment immediately
  As an user
  I'd like to be able to get realtime information
" do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question) }

  describe "Comment ot question" do
    scenario "it appears another user's page", js: true do
      Capybara.using_session("author") do
        sign_in(author)
        visit question_path(question)
      end

      Capybara.using_session("user") do
        visit question_path(question)
      end

      Capybara.using_session("author") do
        within ".question-comments" do
          click_on "Add comment"

          fill_in "Comment body", with: "Comment to question"
          click_on "Save comment"
        end

        within ".comments" do
          expect(page).to have_content "Comment to question"
        end
      end

      Capybara.using_session("user") do
        within ".comments" do
          expect(page).to have_content "Comment to question"
        end
      end
    end
  end

  describe "Comment ot answer" do
    scenario "it appears another user's page", js: true do
      Capybara.using_session("author") do
        sign_in(author)
        visit question_path(question)
      end

      Capybara.using_session("user") do
        visit question_path(question)
      end

      Capybara.using_session("author") do
        within ".answer-comments" do
          click_on "Add comment"

          fill_in "Comment body", with: "Comment to answer"
          click_on "Save comment"
        end
          expect(page).to have_content "Comment to answer"
      end

      Capybara.using_session("user") do
        within ".answer-comments" do
          expect(page).to have_content "Comment to answer"
        end
      end
    end
  end
end