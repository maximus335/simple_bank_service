class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :number, null: false, unique: true
      t.boolean :blocked, null: false, default: false
      t.float :balance, null: false, default: 0.0

      t.timestamps
    end

    add_index :accounts, :number
  end
end
