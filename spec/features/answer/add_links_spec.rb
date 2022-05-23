require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provade additional into to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/vik1972/6375d4e9a56ec049620af6dcabb7cae7' }

  scenario 'Author adds link when asks answer', js: true do
    sign_in(author)
    visit question_path(question)

    fill_in 'Your answer', with: 'Answer text'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'New answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end