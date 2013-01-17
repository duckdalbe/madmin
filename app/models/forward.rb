class Forward < ActiveRecord::Base
  belongs_to :domain
  attr_accessible :destination, :name, :domain_id
  validates :destination, :presence => true,
      :format => { :with => EMAIL_ADDR_REGEXP }
  validates :name, :presence => true, :exclusion => {
      :in => User.find(:all).map(&:name),
      :message => 'is taken by user.' }
  validates :domain, :presence => { :message => 'does not exist' }

  def as_json(options={})
    {
      :name => self.name,
      :id => self.id,
      :destination => self.destination
    }
  end

  def email
    [self.name, self.domain.name].join '@'
  end
end
