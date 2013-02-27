class AddOldPwstringToUser < ActiveRecord::Migration
  def change
    add_column :users, :old_pwstring, :string
  end
end
