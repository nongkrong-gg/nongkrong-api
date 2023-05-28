class AddMidpointLocationToEvent < ActiveRecord::Migration[7.0]
  def change
    add_reference :events, :midpoint_location, type: :uuid, foreign_key: { to_table: :locations }
  end
end
