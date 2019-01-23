class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.string :request_type
      t.string :algorithm_type
      t.string :odr_api_matrix
      t.string :odr_api_uuid
      t.string :solution
      
      t.timestamps
    end
  end
end
