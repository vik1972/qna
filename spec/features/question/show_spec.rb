require "rails_helper"

feature "User can view the question and the answers to it", "
  In order to view the question and the answers to it
  As an  user
  I'd like to able to view the question and the answers to it
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_pair(:answer, question: question) }

  scenario "User to tries question and the answers to it" do
    visit question_path(question)

    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
