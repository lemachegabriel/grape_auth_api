module Root
  class AuthAPI < Grape::API
    resource :auth do
      desc "User login"
      params do
        requires :email, type: String, desc: "User email"
        requires :password, type: String, desc: "User password"
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
