class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  belongs_to :company, optional: true
  has_and_belongs_to_many :events

  # enums
  enum role: { owner: 'owner', employee: 'employee' }

  # Validations
  validates :role, inclusion: { in: roles.keys }
end
