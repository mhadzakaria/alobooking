class BookingsController < ApplicationController
  def index
    @doctors = Doctor.all
    @patients = Patient.all
    @appointments = Appointment.includes(:doctor, :patient).order(start_at: :desc)
  end
end
