class CreateOpenStreetMapRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :open_street_map_requests do |t|
      t.string :min_longitude
      t.string :min_latitude
      t.string :max_longitude
      t.string :max_latitude

      t.string :osm_response_file

      t.timestamps
    end

    add_reference :open_street_map_requests, :request, foreign_key: { on_delete: :cascade }, index: true
  end
end
