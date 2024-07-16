class AddCompanyToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :company, null: false, foreign_key: true
    add_column :users, :role, :string
  end
end
