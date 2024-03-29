# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[destroy update mark_as_best]
  after_action :publish_answer, only: [:create]

  authorize_resource

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    authorize! :update, @answer
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    authorize! :destroy, @answer
    @answer.destroy if current_user.author_of?(@answer)
  end

  def mark_as_best
    @answer.mark_best! if current_user.author_of?(@answer.question)
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast("question_#{@question.id}_answers", answer: @answer)
  end
end
