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

  scenario 'Author adds links when asks answer' do
    sign_in(author)
    visit new_question_path
    fill_in 'Title', with: 'Text question'
    fill_in 'Body', with: 'Text body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
    within '.add_fields' do
      expect(page).to have_content 'add link'
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