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
      can :manage, DyndnsHostname, user_id => user.id
    end
  end
end
