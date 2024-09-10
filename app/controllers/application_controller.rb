class ApplicationController < ActionController::API
  before_action :authenticate_user!

  def authenticate_user!
    token = request.headers['Authorization'].split(' ').last
    decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' })
    user_id = decoded_token[0]['user_id']
    @current_user = User.find(user_id)
  rescue JWT::DecodeError
    render json: { error: 'Invalid token' }, status: :unauthorized
  end

  def current_user
    @current_user
  end
end
