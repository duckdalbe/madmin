class User < ActiveRecord::Base
  belongs_to :domain
  attr_accessible :name, :password, :password_confirmation, :domain_id
  validates :name, :presence => true
  #validates :domain, :inclusion => Domain.find(:all).map(&:id)
  validates :domain, :presence => true
  has_secure_password

  def admin?(domain)
    domain.id == @domain.id && @name == 'postmaster'
  end

  def superadmin?
    @domain.name == 'example.org' && @name == 'postmaster'
  end
end
