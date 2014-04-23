# -*- encoding : utf-8 -*-
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.superadmin?
      can :manage, :all
      if ! allow_dyndns_hostnames?(user.domain.name)
        cannot :manage, DyndnsHostname
      end
    elsif user.admin?
      can [:read, :update], Domain, :id => user.domain.id
      can :manage, [User, Forward], :domain_id => user.domain.id
      if allow_dyndns_hostnames?(user.domain.name)
        can :manage, DyndnsHostname, user.domain.users.select(:id).map(&:id).include?(:user_id)
      end
    else
      can [:read, :update], User, :id => user.id
      # WTF is doing CanCan here? Why do I have to deny :index explicitly?
      cannot :index, User
      if allow_dyndns_hostnames?(user.domain.name)
        can :manage, DyndnsHostname, :user_id => user.id
      end
    end
  end

  def allow_dyndns_hostnames?(domain_name)
    if Array(Settings.dyndns_hostnames.disable).include?(domain_name)
      false
    elsif Settings.dyndns_hostnames.disable == true &&
        ! Array(Settings.dyndns_hostnames.enable).include?(domain_name)
      false
    else
      true
    end
  end
end
