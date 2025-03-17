module Root
  class BaseAPI < Grape::API
    prefix 'api'
    format :json

    mount Root::AuthAPI
    mount Root::UserAPI
  end
end