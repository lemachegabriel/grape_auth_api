module Root
  class BaseAPI < Grape::API
    prefix 'api'
    format :json
    mount Root::AuthAPI
    mount Root::UserAPI

    add_swagger_documentation(
      api_version: 'v1',
      hide_documentation_path: true,
      mount_path: '/swagger_doc',
      hide_format: true,
      info: {
        title: 'Authentication API',
        description: 'API for user creation and authentication with JWT'
      }
    )

  end
end