# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete his question', "
  In order to delete yourself answer
  As an authenticated user
  I'd like to be able to delete my answer
", js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user) }
  given!(:answer_with_attachment) { create(:answer, :with_attachment, user: user) }

  scenario 'Authenticated user destroys own answer' do
    sign_in(answer.user)
    visit question_path answer.question
    click_on 'Delete'

    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated user destroys own attached files' do
    sign_in(answer.user)
    visit question_path(answer_with_attachment.question)
    expect(page).to have_link answer_with_attachment.filename

    within '.attachments' do
      click_on 'Delete file'
    end

    expect(page).to_not have_link answer_with_attachment.filename
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
