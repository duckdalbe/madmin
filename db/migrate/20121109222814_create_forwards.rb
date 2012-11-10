class CreateForwards < ActiveRecord::Migration
  def change
    create_table :forwards do |t|
      t.string :name
      t.string :destination
      t.references :domain

      t.timestamps
    end
    add_index :forwards, :domain_id
  end
end
