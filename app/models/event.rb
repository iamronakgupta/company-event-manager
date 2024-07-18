class Event < ApplicationRecord

  # Association
  has_and_belongs_to_many :employees, class_name: "User"
end
