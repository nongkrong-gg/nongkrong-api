class CreateEventAttendees < ActiveRecord::Migration[7.0]
  def change
    create_table :event_attendees, id: :uuid do |t|
      t.references :event, null: false, type: :uuid, index: true, foreign_key: true
      t.references :attendee, null: false, type: :uuid, index: true, foreign_key: { to_table: :users }
      t.references :attendee_departure_location, null: false, type: :uuid, index: true,
                                                 foreign_key: { to_table: :locations }

      t.timestamps
    end
    add_index :event_attendees, %i[event_id attendee_id], unique: true
  end
end
