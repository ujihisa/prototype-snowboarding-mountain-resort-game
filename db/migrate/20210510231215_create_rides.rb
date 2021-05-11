class CreateRides < ActiveRecord::Migration[6.1]
  def change
    create_table :rides do |t|
      t.json :geojson, null: false
      t.text :message, null: false, limit: 1000

      t.timestamps
    end
  end
end
