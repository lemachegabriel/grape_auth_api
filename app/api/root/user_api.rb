module Root
  class UserAPI < Grape::API
    resource :user do
      desc "Register a new user"
      params do
        requires :name, type: String, desc: "User name"
        requires :email, type: String, desc: "User email"
        requires :password, type: String, desc: "User password"
      end
      post :register do
        user = User.new(email: params[:email], password: params[:password])
        if user.save
          { message: "User registered successfully" }
        else
          error!({ error: user.errors.full_messages }, 400)
        end
      end
    end
  end
end