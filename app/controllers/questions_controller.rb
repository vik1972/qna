# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show destroy update]
  before_action :set_gon, only: [:show]
  after_action :publish_question, only: %i[create]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
  end

  def update
    @question.update(question_params) if current_user&.author_of?(@question)
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def destroy
    @question.destroy if current_user.author_of?(@question)
    redirect_to questions_path
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/show_question',
        locals: {
          question: @question,
          current_user: current_user
        }
      )
    )
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [], links_attributes: %i[name url],
                                     reward_attributes: %i[title image])
  end

  def set_gon
    gon.question_id = @question.id
    gon.current_user_id = current_user&.id
  end
end
