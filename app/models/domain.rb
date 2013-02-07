class Domain < ActiveRecord::Base
  attr_accessible :name
  validates :name, :presence => true, :uniqueness => true
  has_many :users,  :order => :name, :dependent => :destroy
  has_many :forwards, :order => :name, :dependent => :destroy
  before_destroy :any_superadmins_left?

  def any_superadmins_left?
    if User.where("role = 'superadmin' and domain_id != ?", self.id).blank?
      errors[:base] << 'Must not delete the last superadmin!'
      false
    else
      true
    end
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
