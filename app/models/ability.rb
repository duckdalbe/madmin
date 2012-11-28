class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.superadmin?
      can :manage, :all
    elsif user.domadmin?
      can [:read, :update], Domain, :id => user.domain.id
      can :manage, [User, Forward], :domain_id => user.domain.id
    else
      can [:read, :update], User, :id => user.id
      can :manage, Forward, :name => user.name
    end
  end
end
