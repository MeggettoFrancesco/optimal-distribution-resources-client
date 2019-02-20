ActiveAdmin.register Request do
  menu parent: 'Requests'

  actions :all, except: %i[new edit]

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
end
