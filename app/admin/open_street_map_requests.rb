ActiveAdmin.register OpenStreetMapRequest do
  menu parent: 'Requests'

  actions :all, except: %i[new edit]
end
