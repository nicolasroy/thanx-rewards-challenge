class RenameTransactionReferenceToOrder < ActiveRecord::Migration[8.0]
  def change
    remove_reference :points, :transaction, index: true
    add_reference :points, :order, index: true
  end
end
