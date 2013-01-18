class User < ActiveRecord::Base
  belongs_to :domain
  has_secure_password
  attr_accessible :name, :password, :password_confirmation, :domain_id, :role, :forward_destination
  validates :name, :presence => true
  validates :domain, :presence => true
  validates :role, :inclusion => { :in => ROLES }
  # Only validate forward_destination if present.
  # TODO: allow multiple concatenated addresses.
  validates :forward_destination, :presence => true,
      :format => { :with => EMAIL_ADDR_REGEXP },
      :if => Proc.new { |user| user.forward_destination.present? }

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
