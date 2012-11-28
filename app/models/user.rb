class User < ActiveRecord::Base
  ROLES = %w(user admin superadmin)

  belongs_to :domain
  has_many :forwards, :finder_sql => Proc.new {
    %Q{
      select distinct *
      from forwards
      where name = '#{name}' and domain_id = '#{domain_id}'
    }
  }
  attr_accessible :name, :password, :password_confirmation, :domain_id, :role
  validates :name, :presence => true
  validates :domain, :presence => true
  validates :role, :inclusion => { :in => User::ROLES }
  has_secure_password

  def destroyable?
    ! self.postmaster?
  end

  def has_role?(role)
    ROLES.index(role.to_s) <= ROLES.index(self.role.to_s).to_i
  end

  def admin?
    self.postmaster? || has_role?(:admin)
  end

  def postmaster?
    self.name == 'postmaster'
  end

  def superadmin?
    # TODO: find a better algorithm which account to nail as superadmin.
    (self.domain.id == Domain.first.id && self.postmaster?) ||
        has_role?(:superadmin)
  end

  def self.find_by_email(email)
    name, domain_name = email.split('@')
    domain = Domain.find_by_name(domain_name)
    self.where(:name => name, :domain_id => domain.try(:id)).first || false
  end

  def as_json(options={})
    {
      :name => self.name,
      :id => self.id,
      :domain => {
        :id => self.domain.id,
        :name => self.domain.name
        },
      :forwards => self.forwards
    }
  end

  def email
    [self.name, self.domain.name].join '@'
  end
end
