class Doctor < ApplicationRecord
  has_many :doctor_schedules
  has_many :appointments

  validates :name, presence: true
end
