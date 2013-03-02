class User < ActiveRecord::Base
  belongs_to :domain
  has_secure_password
  attr_accessible :name, :password, :password_confirmation, :domain_id, :role, :forward_destination
  validates :name, :presence => true, :uniqueness => { :scope => :domain_id }
  validates :domain, :presence => true
  validates :role, :inclusion => { :in => ROLES }
  # Only validate forward_destination if present.
  # TODO: allow multiple concatenated addresses.
  validates :forward_destination, :presence => true,
      :format => { :with => EMAIL_ADDR_REGEXP },
      :if => Proc.new { |user| user.forward_destination.present? }

  def self.superadmins
    where(role: 'superadmin')
  end

  def self.any_superadmins_left?(obj, field)
    if superadmins.where("#{field} != #{obj.id}").blank?
      obj.errors[:base] << 'Must not delete the last superadmin!'
      false
    else
      true
    end
  end

  def destroyable?
    # Postmaster-account may not be deleted other than with its domain.
    ! self.postmaster? && self.class.any_superadmins_left?(self, :id)
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

  def authenticate(input)
    if password_digest.blank?
      logger.info "BCrypt-attribute is blank, attempting authentication against legacy password"
      if authenticate_oldpw(input)
        logger.info "Saving password into BCrypt-attribute."
        self.password = input
        self.save!
        self
      else
        false
      end
    else
      super(input)
    end
  end

  def authenticate_oldpw(input)
    # split() + join() is way faster than match() or scan()
    salt = old_pwstring.split('$')[0..-2].join('$')
    old_pwstring == input.crypt(salt)
  end
end
