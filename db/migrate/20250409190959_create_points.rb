class CreatePoints < ActiveRecord::Migration[8.0]
  def change
    create_table :points do |t|
      t.string :type
      t.integer :amount
      t.references :user
      t.references :transaction, null: true

      t.timestamps

      t.index [ :type, :user_id ], unique: false
    end
  end
end
