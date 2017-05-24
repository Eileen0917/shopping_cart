class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :recipient
      t.string :tel
      t.string :email
      t.text :note
      t.string :state

      t.timestamps
    end
  end
end
