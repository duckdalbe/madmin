# -*- encoding : utf-8 -*-
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.superadmin?
      can :manage, :all
    elsif user.admin?
      can [:read, :update], Domain, :id => user.domain.id
      can :manage, [User, Forward], :domain_id => user.domain.id
      can :manage, DyndnsHostname, user.domain.users.select(:id).map(&:id).include?(:user_id)
    else
      can [:read, :update], User, :id => user.id
      # WTF is doing CanCan here? Why do I have to deny :index explicitly?
      cannot :index, User
      can :manage, DyndnsHostname, :user_id => user.id
    end
  end
end
