class Api::V1::QuestionsController < Api::V1::BaseController
  skip_authorization_check

  before_action :find_question, only: %i[show update destroy]

  def index
    authorize! :read, Question
    @questions = Question.includes(:answers)
    render json: @questions
  end

  def show
    authorize! :read, Question
    render json: @question, serializer: QuestionOneSerializer
  end

  def create
    authorize! :create, Question
    @question = current_resource_owner.questions.new(question_params)

    if @question.save
      render json: @question, status: :created
    else
      render json: {errors: @question.errors}, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @question

    if @question.update(question_params)
      render json: @question, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @question

    @question.destroy
    render json: { messages: ["Question was successfully deleted."] }
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
