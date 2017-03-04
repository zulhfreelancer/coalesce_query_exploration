class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.datetime :month
      t.boolean :sla
      t.integer :restore_time
      t.integer :start_time

      t.timestamps
    end
  end
end
