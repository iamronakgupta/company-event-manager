class EventsController < ApplicationController
  before_action :set_event, only: [:assign_employees, :update_recurrences]

  def index
    start_date = params[:start_date]
    end_date = params[:end_date]
    events = @current_user.company.events.flat_map do | event |
        json = event.as_json
        json[:events_dates] = event.get_dates_between(start_date, end_date) if event.recurrence
        json
    end
    render json: events, status: :ok
  end

  def create
    event = Event.new(event_params)
    event.company = @current_user.company
    if event.save
      @current_user.events << event
      render json: event, status: :created
    else
      render json: event.errors, status: :unprocessable_entity
    end
  end

  def assign_employees
    employees = @current_user.company.users.where(email: params[:employee_emails])
    emails_added = employees.pluck(:email)

    @event.employees << employees
    render json: {"emails added": emails_added , "email not found": params[:employee_emails]-emails_added}, status: :ok
  rescue
    render json: { errors: "Error assigning employees" }, status: :unprocessable_entity
  end

  def update_recurrences
    case params[:update_type]
    when 'all'
      update_all_recurrences
    when 'future'
      update_future_recurrences
    when 'single'
      update_single_instance
    else
      render json: { errors: "unknown update type" }, status: :unprocessable_entity
    end
  end

  private
  def set_event
    @event = @current_user.events.find(params[:id] )
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: "You are not authorised to this event" }, status: :unprocessable_entity
  end


  def update_all_recurrences
    @event.update(event_params)
    render json: @event, status: :ok
  end

  def update_future_recurrences
    future_event = @event.dup
    @event.update!(ends_on: Date.today)
    future_event.start_date = Date.today
    if future_event.update(event_params)
      render json: future_event, status: :ok
    else
      render json: future_event.errors, status: :unprocessable_entity
    end
  end

  def update_single_instance
    if @event.update(event_params)
      render json: @event, status: :ok
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def event_params
    params.require(:event).permit(:name, :description, :start_date, :start_time, :end_time, :recurring, :recurrence,
      :recurrence_week, :ends_on, repeat_days: [])
  end
end
