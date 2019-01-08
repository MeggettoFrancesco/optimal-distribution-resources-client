ActiveAdmin.register Request do
  permit_params :request_type, :algorithm_type
end
