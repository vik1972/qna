require 'rails_helper'

feature "User can subscribe on the question", "
  In order to have information about new answers
  As an authenticated user
  I would like to able to subscribe on the question
" do

  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe "Authenticated user", js: true do
    describe "Another user" do
      background do
        sign_in(create(:user))
        visit question_path(question)
      end

      scenario "can subscribe" do
        within('.subscription') do
          expect(page).to_not have_content 'Unsubscribe'
          expect(page).to have_content 'Subscribe'

          click_link 'Subscribe'

          expect(page).to have_content 'Unsubscribe'
          expect(page).to_not have_content 'Subscribe'
        end
      end
    end

    describe "Author" do
      background do
        sign_in(author)
        visit question_path(question)
      end

      scenario "can unsubscribe" do
        within('.subscription') do
          expect(page).to_not have_link 'Subscribe'
          expect(page).to have_link 'Unsubscribe'

          click_on 'Unsubscribe'

          expect(page).to have_link 'Subscribe'
          expect(page).to_not have_link 'Unsubscribe'
        end
      end
    end
  end

  describe "Unauthenticated user", js: true do
    background do
      visit question_path(question)
    end

    scenario "can't subscribe or unsubscribe" do
      expect(page).to_not have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end
end