class EventsController < ApplicationController

  def create
    @event = @current_user.events.build(event_params)
    if @event.save
      render json: @event, status: :created
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  private
  def event_params
    params.require(:event).permit(:name, :description, :start_date, :start_time, :end_time, :recurring, :recurrence,
      :recurrence_week, :repeat_days, :ends_on)
  end

  def employee_emails_params
    params.require(:event).permit(employee_emails: [])
  end
end
