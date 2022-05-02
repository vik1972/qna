require 'rails_helper'

feature 'User can delete his question', %q{
  In order to delete yourself question
  As an authenticated user
  I'd lake to be able to delete the question
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
end