class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :create_owner

  def create_owner
    ActiveRecord::Base.transaction do
      company = Company.create!(name: params[:company_name])
      user = company.users.create!(user_params.merge(role: 'owner'))

      render json: { user: user, company: company }, status: :created
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
