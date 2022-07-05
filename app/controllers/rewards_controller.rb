# frozen_string_literal: true

class RewardsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  skip_authorization_check
  def index
    @rewards = current_user.rewards
  end
end
