class Event < ApplicationRecord
  # Validation
  validates :name, :description, :start_date, :start_time, :end_time, presence: true
  validates :recurrence, inclusion: { in: [ true, false ] }
  validates :recurrence_week, :repeat_days, presence: true, if: -> {recurrence == true}
  # Association
  has_and_belongs_to_many :employees, class_name: "User"


end
