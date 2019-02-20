class CreateInputMatrixRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :input_matrix_requests do |t|
      t.boolean :is_directed_graph

      t.timestamps
    end

    add_reference :input_matrix_requests, :request, foreign_key: { on_delete: :cascade }, index: true
  end
end
