class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.superadmin?
      can :manage, :all
    elsif user.admin?
      can [:read, :update], Domain, :id => user.domain.id
      can :manage, [User, Forward], :domain_id => user.domain.id
    else
      can [:read, :update], User, :id => user.id
    end
  end
end
