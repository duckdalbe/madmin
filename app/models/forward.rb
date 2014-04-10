class Forward < ActiveRecord::Base
  belongs_to :domain
  attr_accessible :destination, :name, :domain_id
  validates :name,
            presence: { format: { with: EMAIL_LOCALPART_REGEXP } },
            uniqueness: { scope: :domain_id },
            exclusion: { in: lambda { |fw| Domain.users_names(fw.domain_id) },
                         message: 'is taken by user.' }
  validates :domain, presence: { message: 'does not exist' }
  validates :destination, presence: { format: { with: EMAIL_ADDR_REGEXP } }

  default_scope order(:name)

  def self.latest(limit=20)
    order(:created_at).limit(limit)
  end

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
