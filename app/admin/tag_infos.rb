ActiveAdmin.register TagInfo do
  permit_params :tag_key, :tag_value, open_street_map_request_ids: []

  filter :tag_key
  filter :tag_value
  filter :open_street_map_requests
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :tag_key
    column :tag_value
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :tag_key
      f.input :tag_value
      f.input :open_street_map_requests, include_blank: true
    end
    f.actions
  end

  show do
    attributes_table do
      row :tag_key
      row :tag_value
      table_for tag_info.open_street_map_requests do
        column(:open_street_map_requests) do |osm_request|
          link_to osm_request.id, [:admin, osm_request]
        end
      end
      row :created_at
      row :updated_at
    end
  end
end
