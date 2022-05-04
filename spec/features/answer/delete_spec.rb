require 'rails_helper'

feature 'User can delete his question', %q{
  In order to delete yourself answer
  As an authenticated user
  I'd like to be able to delete my answer
}do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }

  scenario 'Authenticated user destroys own answer' do
    sign_in(answer.user)
    visit question_path answer.question
    click_on 'Delete answer'

    expect(page).to_not have_content answer.body
  end

  scenario "Authenticated user can't destroy other user's answer" do
    sign_in(user)
    visit question_path answer.question

    expect(page).to_not have_link 'Delete answer'
  end

  scenario "Unauthenticated user destroys other user's answer" do
    visit question_path answer.question

    expect(page).to_not have_link 'Delete answer'
  end
end