class CreateLineItems < ActiveRecord::Migration[8.0]
  def change
    create_table :line_items do |t|
      t.references :order, null: false
      t.references :itemizable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
