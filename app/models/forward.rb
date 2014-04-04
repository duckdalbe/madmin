class Forward < ActiveRecord::Base
  belongs_to :domain
  attr_accessible :destination, :name, :domain_id
  # TODO: validate that the name only contains valid characters.
  validates :name,
            presence: true,
            uniqueness: { scope: :domain_id },
            exclusion: { in: lambda { |fw|
                User.select(:name).where(domain_id: fw.domain_id).map(&:name) },
                         message: 'is taken by user.' }
  validates :domain, presence: { message: 'does not exist' }
  validates :destination, presence: { format: { with: EMAIL_ADDR_REGEXP } }

  default_scope order(:name)

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
