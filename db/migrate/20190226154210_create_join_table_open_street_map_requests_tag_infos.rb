class CreateJoinTableOpenStreetMapRequestsTagInfos < ActiveRecord::Migration[5.2]
  def change
    create_join_table :open_street_map_requests, :tag_infos do |t|
      t.index %i[open_street_map_request_id tag_info_id], name: 'index_osm_request_id_and_tag_info_id'
    end
  end
end
