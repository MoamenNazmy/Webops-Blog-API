class AuthController < ApplicationController
   skip_before_action :authenticate_user!, only: [:signup, :login]
   def signup
     # Signup logic (e.g., create a new user)
     user = User.new(user_params)
     if user.save
       render json: { message: 'User created successfully' }, status: :created
     else
       render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
     end
   end

   def login
    user = User.find_by(email: login_params[:email])

    # Authenticate user with bcrypt's has_secure_password
    if user&.authenticate(login_params[:password])
      token = encode_token(user_id: user.id)
      render json: { token: token, message: 'Login successful' }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
   end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :image)
    end

    def login_params
    params.require(:user).permit(:email, :password)
    end

    def encode_token(payload)
        JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end
  end
  