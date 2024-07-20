class Event < ApplicationRecord
  serialize :repeat_days, coder: YAML
  # Validation
  validates :name, :description, :start_date, :start_time, :end_time, presence: true
  validates :recurrence, inclusion: { in: [ true, false ] }
  validates :recurrence_week, :repeat_days, presence: true, if: -> {recurrence == true}
  validate :repeat_days_must_be_valid
  validates :recurrence_week, numericality: { greater_than: 0 }

  # Association
  has_and_belongs_to_many :employees, class_name: "User"
  belongs_to :company


  def repeat_days_must_be_valid
    valid_days = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].map(&:downcase)
    if repeat_days.nil? || !repeat_days.is_a?(Array) || (repeat_days.map(&:downcase) - valid_days).any?
      errors.add(:repeat_days, "must be an array of valid weekdays")
    end
  end

  def get_dates_between(start_date, end_date)
    days_of_week = repeat_days
    week_interval = recurrence_week
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    days_of_week = days_of_week.map(&:capitalize)

    result_dates = []
    current_date = start_date

    while current_date <= end_date
      if days_of_week.include?(current_date.strftime('%A'))
        result_dates << current_date
      end

      current_date += 1

      if current_date.strftime('%A') == 'Sunday' && week_interval > 1
        current_date += (week_interval - 1) * 7
      end
    end
    result_dates
  end
end
