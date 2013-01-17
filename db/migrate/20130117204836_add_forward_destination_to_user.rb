class AddForwardDestinationToUser < ActiveRecord::Migration
  def change
    add_column :users, :forward_destination, :string
  end
end
