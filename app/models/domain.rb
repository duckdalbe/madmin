class Domain < ActiveRecord::Base
  attr_accessible :name
  has_many :users, :dependent => :restrict
  has_many :forwards, :dependent => :restrict
end
