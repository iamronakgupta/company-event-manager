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

  def create_employee
    if @current_user.role == "owner"
      user = @current_user.company.users.create!(user_params.merge(role: 'employee'))
      render json: { user: user }, status: :created
    else
      render json: { errors: "You are not an owner" }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
