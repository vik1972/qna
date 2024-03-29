# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :me, User, user_id: user.id
    can :index, User, user_id: user.id

    can :create, [Question, Answer, Comment, Subscription]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer, Subscription], user_id: user.id

    can :destroy, ActiveStorage::Attachment do |file|
      user.author_of?(file.record)
    end

    can :destroy, Link, linkable: { user_id: user.id }

    can :mark_as_best, Answer, question: { user_id: user.id }

    can %i[vote_up vote_down cancel_vote], [Answer, Question] do |votable|
      !user.author_of?(votable)
    end
  end
end

# See the wiki for details:
# https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md