class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.belongs_to :account, foreign_key: true, on_delete: :cascade
      t.float :amount, null: false
      t.string :from
      t.string :to
      t.string :type_operation, null: false

      t.timestamps
    end

    add_index :transactions, :created_at
  end
end
