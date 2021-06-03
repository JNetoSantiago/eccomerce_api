class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :description, null: false
      t.index :description, unique: true
      t.integer :status, null: false, default: 1

      t.timestamps
    end
  end
end
