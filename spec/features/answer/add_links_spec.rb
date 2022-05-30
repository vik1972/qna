require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provade additional into to my answer
  As an answer's author
  I'd like to be able to add links
}do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question) }
  given(:url) { 'https://google.ru' }
  given(:gist_url) { 'https://gist.github.com/vik1972/6375d4e9a56ec049620af6dcabb7cae7' }

  describe 'Author' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'adds link when asks answer', js: true do
      fill_in 'Your answer', with: 'Answer text'
      fill_in 'Link name', with: 'google'
      fill_in 'Url', with: url

      click_on 'New answer'

      within '.answers' do
        expect(page).to have_link 'google', href: url
      end
    end

    scenario 'adds link to GitHab when asks answer', js: true do
      fill_in 'Your answer', with: 'Answer text'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'New answer'

      within '.gist' do
        expect(page).to have_content "Hello, it is my Gist"
      end
    end

    scenario 'adds links when asks answer', js: true do
      fill_in 'Your answer', with: 'Answer text'

      click_on 'add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'google-2'
        fill_in 'Url', with: url
      end
      click_on 'New answer'

      expect(page).to have_link 'google-2', href: url
    end
  end

  scenario 'User trys to ads link to another answer' do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'New answer'
  end

  scenario 'Unauthenticated user trys to ads link to another answer' do
    visit question_path(question)

    expect(page).to_not have_link 'New answer'
  end

end