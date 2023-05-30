class ChangeFinalLocationOfEventToString < ActiveRecord::Migration[7.0]
  def change
    remove_reference :events, :final_location, index: true, foreign_key: { to_table: :locations }
    add_column :events, :final_location, :string
  end
end
