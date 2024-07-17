class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.date :start_date
      t.time :start_time
      t.time :end_time
      t.date :ends_on
      t.string :repeat_days
      t.boolean :recurrence, null: false
      t.integer :recurrence_week

      t.timestamps
    end
  end
end
