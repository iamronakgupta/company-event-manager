class AddCompanyToEvents < ActiveRecord::Migration[7.1]
  def change
    add_reference :events, :company, foreign_key: true
  end
end
