class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient

  # Validations
  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :end_at, comparison: { greater_than: :start_at, message: "must be after start time" }, if: :start_at
  validate :must_be_future, on: :create
  validate :within_doctor_schedule

  enum :status, {
    upcoming: 'upcoming',
    confirmed: 'confirmed',
    completed: 'completed',
    cancelled: 'cancelled',
    not_show: 'not_show'
  }, default: 'upcoming'

  # Scopes
  scope :upcoming_appointments, -> { upcoming.where('start_at > ?', Time.current) }

  def must_be_future
    errors.add(:start_at, "must be in the future") if start_at.present? && start_at < Time.current
  end

  def within_doctor_schedule
    # TODO: Add option using time slot not only range, like 08:00 - 10:00, 12:00 - 14:00, etc
    return unless start_at && doctor

    dow = start_at.wday
    schedule = doctor.doctor_schedules.find_by(day_of_week: dow, active: true)
    
    unless schedule
      errors.add(:base, "Doctor is not available on this day")
      return
    end

    # Simple validation checking
    appt_start_time = start_at.strftime("%H:%M")
    appt_end_time = end_at.strftime("%H:%M")
    sched_start_time = schedule.start_time.strftime("%H:%M")
    sched_end_time = schedule.end_time.strftime("%H:%M")

    if appt_start_time < sched_start_time || appt_end_time > sched_end_time
      errors.add(:base, "Appointment time is outside doctor's working hours")
    end
  end
end
