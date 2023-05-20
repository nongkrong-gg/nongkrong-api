class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events, id: :uuid do |t|
      t.string :title, null: false
      t.text :description
      t.datetime :date, null: false
      t.references :organizer, null: false, type: :uuid, index: true, foreign_key: { to_table: :users }
      t.references :location, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
  end
end
