require "rails_helper"

feature "Attachments to answer", "
  In order to illustrate my answer
  As an author of question
  I'd like to be able to attach files
", js: true do
  given(:author) { create(:user) }
  given(:user) { create(:user) }

  given!(:answer_with_attachment) { create(:answer, :with_attachment, user: author) }
  given!(:question_with_attachment) { create(:question, :with_attachment, user: author) }

  describe "Author of answer" do
    background { sign_in author }

    scenario "delete attached files from answer" do
      visit question_path(answer_with_attachment.question)
      expect(page).to have_link answer_with_attachment.filename

      within ".attachments" do
        click_on "Delete file"
      end
      expect(page).to_not have_link answer_with_attachment.filename
    end
  end

  scenario "Not an author try to delete attached files from answer" do
    sign_in user
    visit question_path(answer_with_attachment.question)

    expect(page).to have_link answer_with_attachment.filename
    expect(page).to_not have_link "Delete file"
  end

  scenario "Non authorized user try to delete attached files from answer" do
    visit question_path(answer_with_attachment.question)

    expect(page).to have_link answer_with_attachment.filename
    expect(page).to_not have_link "Delete file"
  end

  describe "Author of question" do
    background { sign_in author }

    scenario "delete attached files from question" do
      visit questions_path
      expect(page).to have_link question_with_attachment.filename

      within ".attachments" do
        click_on "Delete file"
      end
      expect(page).to_not have_link question_with_attachment.filename
    end
  end

  scenario "Not an author try to delete attached files from question" do
    sign_in user
    visit questions_path

    expect(page).to have_link question_with_attachment.filename
    expect(page).to_not have_link "Delete file"
  end

  scenario "Non authorized user try to delete attached files from question" do
    visit questions_path

    expect(page).to have_link question_with_attachment.filename
    expect(page).to_not have_link "Delete file"
  end
end
