module Root
  class UserAPI < Grape::API
    helpers do
      def authenticate!
        error!({ error: 'Unauthorized. Token required' }, 401) unless headers['Authorization']
        
        token = headers['Authorization'].gsub('Bearer ', '')
        begin
          payload = JWT.decode(token, Rails.application.credentials[:secret_key_base], true, algorithm: 'HS256')[0]
          @current_user = User.find(payload['user_id'])
        rescue JWT::DecodeError, ActiveRecord::RecordNotFound
          error!({ error: 'Unauthorized. Invalid token' }, 401)
        end
      end

      def authorize!(user)
        error!({ error: 'Forbidden' }, 403) unless @current_user && (@current_user.id == user.id)
      end

      def current_user
        @current_user
      end
    end

    resource :user do
      desc "Register a new user" do
        tags ['Users']
        detail 'This endpoint creates a new user account with the provided information'
        produces ['application/json']
        consumes ['application/json']
        named 'register_user'
      end
      params do
        requires :name, type: String, desc: "User name", documentation: { example: "Gabriel" }
        requires :email, type: String, desc: "User email", documentation: { example: "user@example.com" }
        requires :password, type: String, desc: "User password", documentation: { example: "securepass123" }
      end
      post :register do
        user = User.new(name: params[:name], email: params[:email], password: params[:password])
        if user.save
          { message: "User registered successfully" }
        else
          error!({ error: user.errors.full_messages }, 400)
        end
      end

      desc "Get user details" do
        tags ['Users']
        detail 'Returns details for a specific user'
        headers Authorization: {
          description: 'JWT token',
          required: true
        }
      end
      params do
        requires :id, type: Integer, desc: "User ID"
      end
      get ':id' do
        authenticate!

        user = User.find_by(id: params[:id])
        if user
          authorize! user
          present user
        else
          error!({ error: "User not found" }, 404)
        end
      end

      desc "Update user information" do
        tags ['Users']
        detail 'Updates information for a specific user'
        headers Authorization: {
          description: 'JWT token',
          required: true
        }
      end
      params do
        requires :id, type: Integer, desc: "User ID"
        optional :name, type: String, desc: "User name"
        optional :email, type: String, desc: "User email"
        optional :password, type: String, desc: "User password"
        at_least_one_of :name, :email, :password
      end
      put ':id' do
        authenticate!
        
        user = User.find_by(id: params[:id])
        if !user
          error!({ error: "User not found" }, 404)
        end

        authorize! user

        update_params = {}
        update_params[:name] = params[:name] if params[:name]
        update_params[:email] = params[:email] if params[:email]
        update_params[:password] = params[:password] if params[:password]
        
        if user.update(update_params)
          present user
        else
          error!({ error: user.errors.full_messages }, 400)
        end
      end
    end
  end
end