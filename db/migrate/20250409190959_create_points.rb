class CreatePoints < ActiveRecord::Migration[8.0]
  def change
    create_table :points do |t|
      t.integer :amount
      t.references :user
      t.references :transaction, null: true

      t.timestamps
    end
  end
end
