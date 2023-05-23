class RenameLocationColumnInEvent < ActiveRecord::Migration[7.0]
  def change
    rename_column :events, :location_id, :final_location_id
  end
end
