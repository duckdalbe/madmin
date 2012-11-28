class Domain < ActiveRecord::Base
  attr_accessible :name
  has_many :users,  :order => :name, :dependent => :destroy
  has_many :forwards, :order => :name, :dependent => :destroy

  def as_json(options={})
    {
      :name => self.name,
      :id => self.id,
      :users => self.users,
      :forwards => self.forwards
    }
  end
end
