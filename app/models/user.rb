class User < ActiveRecord::Base
  belongs_to :domain
  attr_accessible :name, :password, :password_confirmation, :domain_id
  validates :name, :presence => true
  validates :domain, :presence => true
  has_secure_password

  def admin?(domain)
    domain.id == self.domain.id && self.name == 'postmaster'
  end

  def superadmin?
    self.domain.name == 'example.org' && self.name == 'postmaster'
  end
end
