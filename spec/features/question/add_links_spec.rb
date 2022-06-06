# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to provade additional into to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:url) { 'https://google.ru' }
  given(:gist_url) { 'https://gist.github.com/vik1972/6375d4e9a56ec049620af6dcabb7cae7' }

  background do
    sign_in(author)
    visit new_question_path
  end

  scenario 'Author adds link to Gist when asks question', js: true do
    fill_in 'Title', with: 'Text question'
    fill_in 'Body', with: 'Text body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'
    within('.gist') do
      expect(page).to have_content 'Hello, it is my Gist'
    end
  end

  scenario 'Author adds links when asks question', js: true do
    fill_in 'Title', with: 'Text question'
    fill_in 'Body', with: 'Text body'

    click_on 'add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'google-2'
      fill_in 'Url', with: url
    end
    click_on 'Ask'
    expect(page).to have_link 'google-2', href: url
  end
end
