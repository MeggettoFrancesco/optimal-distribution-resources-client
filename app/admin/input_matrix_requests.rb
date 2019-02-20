ActiveAdmin.register InputMatrixRequest do
  menu parent: 'Requests'

  actions :all, except: %i[new edit]
end
