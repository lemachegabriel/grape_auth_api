module Root
  class AuthAPI < Grape::API
    resource :auth do
      desc "User login" do
        tags ['Authentication']
        detail 'This endpoint authenticates a user with email and password, returning a JWT token upon success'
        produces ['application/json']
        consumes ['application/json']
        named 'user_login'
      end
      params do
        requires :email, type: String, desc: "User email", documentation: { example: "user@example.com" }
        requires :password, type: String, desc: "User password", documentation: { example: "securepass123" }
      end
      post :login do
        user = User.find_by(email: params[:email])

        if user && user.authenticate(params[:password])
          token = JWT.encode({ user_id: user.id }, 'your_secret_key', 'HS256')
          { token: token }
        else
          error!({ error: "Invalid email or password" }, 401)
        end
      end
    end
  end
end