class Forward < ActiveRecord::Base
  belongs_to :domain
  attr_accessible :destination, :name, :domain_id
  validates :name, uniqueness: { scope: :domain_id, message: 'is taken by user.' }
  validates :domain, presence: { message: 'does not exist' }
  validates :destination, presence: { format: { with: EMAIL_ADDR_REGEXP } }

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
