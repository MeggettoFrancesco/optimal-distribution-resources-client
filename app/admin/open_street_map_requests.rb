ActiveAdmin.register OpenStreetMapRequest do
  menu parent: 'Requests'

  actions :all, except: :new

  permit_params tag_info_ids: []

  form do |f|
    f.inputs do
      f.input :tag_infos, include_blank: true
    end
    f.actions
  end

  show do
    attributes_table do
      row :min_longitude
      row :min_latitude
      row :max_longitude
      row :max_latitude
      row :osm_response_file
      row :request
      table_for open_street_map_request.tag_infos do
        column(:tag_infos) do |tag_info|
          link_to tag_info.id, [:admin, tag_info]
        end
      end
      row :created_at
      row :updated_at
    end
  end
end
