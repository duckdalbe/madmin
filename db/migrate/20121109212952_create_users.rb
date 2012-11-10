class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.references :domain

      t.timestamps
    end
    add_index :users, :domain_id
  end
end
