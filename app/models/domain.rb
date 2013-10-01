class Domain < ActiveRecord::Base
  attr_accessible :name
  validates :name, :presence => true, :uniqueness => true
  has_many :users,  :order => :name, :dependent => :destroy
  has_many :forwards, :order => :name, :dependent => :destroy
  before_destroy :destroyable?
  after_destroy :delete_domain_data

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
end
