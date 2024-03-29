class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
  before_action :set_gon, only: :create
  after_action :publish_comment, only: :create

  skip_authorization_check

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def set_commentable
    @resource, @resource_id = request.path.split('/')[1, 2]
    @resource = @resource.singularize
    @commentable = @resource.classify.constantize.find(@resource_id)
  end

  def publish_comment
    return if @comment.errors.any?
    question_id = @commentable.class == Question ? @commentable.id : @commentable.question_id
    ActionCable.server.broadcast(
      "question_#{question_id}_comments",
      comment: @comment,
      user: @comment.user
    )
  end

  def set_gon
    gon.resource_klass = @commentable.class
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
