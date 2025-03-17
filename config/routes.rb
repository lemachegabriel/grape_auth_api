Rails.application.routes.draw do
  mount GrapeSwaggerRails::Engine => '/swagger'
  mount Root::BaseAPI => "/"
end
