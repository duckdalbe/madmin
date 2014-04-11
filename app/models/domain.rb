# -*- encoding : utf-8 -*-
class Domain < ActiveRecord::Base
  attr_accessible :name
  validates :name, :presence => true, :uniqueness => true
  has_many :users,  :order => :name, :dependent => :destroy
  has_many :forwards, :order => :name, :dependent => :destroy
  before_destroy :destroyable?
  after_destroy :delete_domain_data

  default_scope order(:name)

  def self.users_names(domain_id)
    resource_names(User, domain_id)
  end

  def self.forwards_names(domain_id)
    resource_names(Forward, domain_id)
  end

  def admins
    users.where(role: 'admin')
  end

  def delete_domain_data
    logger.info "Deleting domain-data for #{self}:"
    logger.info `#{Rails.root}/bin/delete-mail-data.sh '#{domain.name}'`.chomp
  end

  def destroyable?
    User.any_superadmins_left?(self, :domain_id)
  end

  def as_json(options={})
    {
      :name => self.name,
      :id => self.id,
      :users => self.users,
      :forwards => self.forwards
    }
  end
  
  def to_s
    name
  end

  private

  def self.resource_names(klass, domain_id)
    klass.select(:name).where(domain_id: domain_id).map(&:name)
  end
end
