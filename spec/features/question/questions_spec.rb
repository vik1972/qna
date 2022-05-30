require "rails_helper"

feature "User can view the list of questions", "
  In order to views list of questions
  As an user
  I'd like to view list of questions
" do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }

  scenario "User tries to view list of questions" do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content(question.title)
    end
  end
end
