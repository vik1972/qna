# frozen_string_literal: true

require 'rails_helper'

feature 'User can show reward', "
  In order to view a list of his awards
  I'd like to be able to view my badges
" do
  given(:user) { create :user }
  given(:question) { create :question, user: user }

  scenario 'Authenticated user tries to browse rewards', js: true do
    sign_in(user)
    rewards = create_list(:reward, 4, user: user, question: question)
    visit rewards_path

    rewards.each do |reward|
      expect(page).to have_content reward.question.title
      expect(page).to have_content reward.title
      expect(page).to have_css 'img'
    end
  end

  scenario 'Unauthenticated user tries to browse rewards' do
    visit questions_path

    expect(page).to_not have_link 'Rewards'
  end
end
