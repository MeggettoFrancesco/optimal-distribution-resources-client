class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.string :request_type

      t.string :algorithm_type
      t.string :odr_api_matrix
      t.integer :odr_api_path_length
      t.string :odr_api_number_resources
      t.boolean :odr_api_cycles
      t.string :odr_api_uuid

      t.string :solution

      t.timestamps
    end
  end
end
