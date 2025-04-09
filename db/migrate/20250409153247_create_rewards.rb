class CreateRewards < ActiveRecord::Migration[8.0]
  def change
    create_table :rewards do |t|
      t.string :title
      t.text :content
      t.string :image
      t.integer :points

      t.timestamps
    end
  end
end
