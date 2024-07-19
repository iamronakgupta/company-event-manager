class Event < ApplicationRecord
  serialize :repeat_days, coder: YAML
  # Validation
  validates :name, :description, :start_date, :start_time, :end_time, presence: true
  validates :recurrence, inclusion: { in: [ true, false ] }
  validates :recurrence_week, :repeat_days, presence: true, if: -> {recurrence == true}
  validate :repeat_days_must_be_valid

  # Association
  has_and_belongs_to_many :employees, class_name: "User"
  belongs_to :company


  def repeat_days_must_be_valid
    valid_days = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].map(&:downcase)
    if repeat_days.nil? || !repeat_days.is_a?(Array) || (repeat_days.map(&:downcase) - valid_days).any?
      errors.add(:repeat_days, "must be an array of valid weekdays")
    end
  end
end
