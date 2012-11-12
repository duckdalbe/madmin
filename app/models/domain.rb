class Domain < ActiveRecord::Base
  attr_accessible :name
  has_many :users, :dependent => :restrict
  has_many :forwards, :dependent => :restrict

  def as_json(options={})
    {
      :name => self.name,
      :id => self.id,
      :users => self.users,
      :forwards => self.forwards
    }
  end
end
