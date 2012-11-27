class Forward < ActiveRecord::Base
  belongs_to :domain
  attr_accessible :destination, :name, :domain_id
  validates :destination, :presence => true,
      :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
  validates :name, :presence => true
  validates :domain, :presence => { :message => 'does not exist' }

  def as_json(options={})
    {
      :name => self.name,
      :id => self.id,
      :destination => self.destination
    }
  end

  def user
    User.find_by_name_and_domain_id self.name, self.domain
  end

  def email
    [self.name, self.domain.name].join '@'
  end
end
