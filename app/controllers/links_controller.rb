# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!, only: %i[destroy]
  before_action :find_link

  skip_authorization_check

  def destroy
    @link.destroy if current_user&.author_of?(@link.linkable)
  end

  private

  def find_link
    @link = Link.find(params[:id])
  end
end
