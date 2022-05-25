require 'rails_helper'

feature 'User can delete link to answer', %q{
  In order to remove additional data from my answer
  As an answer's author
  I'd like to be able remove links
}do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given!(:link) { create(:link, linkable: answer) }

  scenario 'Author can delete link from his answer', js: true do
    sign_in(author)
    visit question_path(question)

    within "#link_#{link.id}" do
      expect(page).to have_link link.name, href: link.url
      click_on 'Delete link'
    end
    expect(page).to_not have_link link.name, href: link.url
  end

end