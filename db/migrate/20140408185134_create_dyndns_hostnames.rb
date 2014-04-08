class CreateDyndnsHostnames < ActiveRecord::Migration
  def change
    create_table :dyndns_hostnames do |t|
      t.string :name
      t.references :user

      t.timestamps
    end
    add_index :dyndns_hostnames, :user_id
  end
end
