# -*- encoding : utf-8 -*-
class DyndnsHostname < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name, :user_id

  validates :name, :presence => true,
                   :uniqueness => true,
                   :format => { :with => /[a-z0-9,-_]/ }
  validates :user, :presence => true

  def as_json(options={})
    @json ||= {
      name: self.name,
      id: self.id,
      user: self.user
    }
  end
end
