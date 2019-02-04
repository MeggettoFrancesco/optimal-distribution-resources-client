ActiveAdmin.register Request do
  actions :all, except: :edit

  filter :request_type
  filter :algorithm_type
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :request_type
    column :algorithm_type
    column :odr_api_matrix do |my_resource|
      truncate(my_resource.odr_api_matrix, length: 100)
    end
    column :odr_api_path_length
    column :odr_api_number_resources
    column :odr_api_cycles
    column :solution
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :request_type
      row :algorithm_type
      row :odr_api_matrix
      row :odr_api_path_length
      row :odr_api_number_resources
      row :odr_api_cycles
      row :odr_api_uuid
      row :solution
      row :created_at
      row :updated_at
      active_admin_comments
    end
  end
end
