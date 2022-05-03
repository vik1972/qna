require 'rails_helper'

feature 'User can delete his question', %q{
  In order to delete yourself question
  As an authenticated user
  I'd lake to be able to delete my question
}do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'Author delete his question' do
    sign_in(author)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to_not have_content question.title
  end

  scenario "Authenticated user can't destroy other user's question" do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

  scenario "Unauthenticated user can't destroy question" do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end