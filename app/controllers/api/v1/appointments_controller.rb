module Api
  module V1
    class AppointmentsController < ActionController::API
      # Why this rescue on controller: This code should be in service layer, but for now i put it here.
      #   Since app still small.
      rescue_from ActiveRecord::RecordInvalid, with: :render_validation_error
      rescue_from ActiveRecord::RecordNotUnique, with: :render_double_booking_error
      rescue_from PG::ExclusionViolation, with: :render_overlap_error

      def create
        start_time = Time.parse(appointment_params[:start_at]) rescue nil
        end_time = Time.parse(appointment_params[:end_at]) rescue nil
        if !start_time || !end_time
            return render json: { error: "Invalid date format" }, status: :unprocessable_entity
        end

        @appointment = Appointment.new(
          doctor_id: appointment_params[:doctor_id],
          patient_id: appointment_params[:patient_id],
          start_at: start_time,
          end_at: end_time
        )

        if @appointment.save
          render json: {
            message: "Appointment booked successfully",
            data: @appointment
          }, status: :created
        else
          render_validation_error(@appointment)
        end
      end

      private

      def appointment_params
        params.require(:appointment).permit(:doctor_id, :patient_id, :start_at, :end_at)
      end

      def render_validation_error(exeception_or_record)
        record = exeception_or_record.is_a?(ActiveRecord::RecordInvalid) ? exeception_or_record.record : exeception_or_record
        render json: {
          error: "Validation failed",
          details: record&.errors&.full_messages
        }, status: :unprocessable_entity
      end

      def render_double_booking_error(exception)
        render json: {
          error: "Double booking detected",
          message: "You have already booked an appointment with this doctor at this time."
        }, status: :conflict
      end

      def render_overlap_error(exception)
        render json: {
          error: "Time slot unavailable",
          message: "The doctor has another appointment overlapping with this time."
        }, status: :conflict
      end
    end
  end
end
