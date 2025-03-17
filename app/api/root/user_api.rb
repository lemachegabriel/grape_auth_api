module Root
  class UserAPI < Grape::API
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
    end
  end
end