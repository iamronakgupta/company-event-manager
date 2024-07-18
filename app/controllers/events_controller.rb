class EventsController < ApplicationController
  before_action :set_event, only: [:assign_employees]
  def create
    event = Event.new(event_params)
    if @current_user.events << event
      render json: event, status: :created
    else
      render json: event.errors, status: :unprocessable_entity
    end
  end

  def assign_employees
    employees = @current_user.company.users.where(email: params[:employee_emails])
    if @event.employees << employees
      render json: {"emails added": employees.pluck(:email), "email not found": params[:employee_emails]-employees.pluck(:email)}, status: :ok
    else
      render json: { errors: "Error assigning employees" }, status: :unprocessable_entity
    end
  end

  private
  def set_event
    @event = @current_user.events.find(params[:id] )
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: "You are not authorised to edit this event" }, status: :unprocessable_entity
  end

  def event_params
    params.require(:event).permit(:name, :description, :start_date, :start_time, :end_time, :recurring, :recurrence,
      :recurrence_week, :repeat_days, :ends_on)
  end
end
