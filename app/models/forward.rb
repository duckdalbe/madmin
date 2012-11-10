class Forward < ActiveRecord::Base
  belongs_to :domain
  attr_accessible :destination, :name, :domain_id
  validates :destination, :presence => true,
      :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
  validates :name, :presence => true
  validates :domain, :presence => { :message => 'does not exist' }
end
