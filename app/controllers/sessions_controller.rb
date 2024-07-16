class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: :create

  def create
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: { errors: 'Invalid email or password' }, status: :unauthorized
    end
  end
end
