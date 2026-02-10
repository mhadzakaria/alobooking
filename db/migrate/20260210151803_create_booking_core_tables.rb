class CreateBookingCoreTables < ActiveRecord::Migration[8.0]
  def change
    enable_extension "btree_gist"

    # =========================
    # DOCTORS & PATIENTS
    # =========================
    create_table :doctors do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :patients do |t|
      t.string :name, null: false
      t.timestamps
    end

    # =========================
    # DOCTOR SCHEDULES
    # =========================
    create_table :doctor_schedules do |t|
      t.references :doctor, null: false, foreign_key: true
      t.integer :day_of_week, null: false # 0 = Sunday
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :doctor_schedules, [:doctor_id, :day_of_week]


    # =========================
    # APPOINTMENTS
    # =========================
    create_table :appointments do |t|
      t.references :doctor, null: false, foreign_key: true
      t.references :patient, null: false, foreign_key: true

      t.datetime :start_at, null: false
      t.datetime :end_at, null: false

      t.string :status, null: false, default: "upcoming"

      t.timestamps
    end

    add_index :appointments, :start_at

    # Prevent double submission
    add_index :appointments,
              [:doctor_id, :patient_id, :start_at],
              unique: true,
              where: "status != 'cancelled'",
              name: "index_appointments_no_duplicate_booking"

    # =========================
    # Prevent overlapping appointments
    # Why this apporach: I'm using this approach to make sure data consistency.
    #   I want to make what ever the flow, DB will be the source of truth.
    #   So even if the model validation is bypassed, the DB will reject the overlapping appointments.
    #   Because this is critical business rule.
    # =========================
    reversible do |dir|
      dir.up do
        execute <<~SQL
          ALTER TABLE appointments
          ADD CONSTRAINT no_overlapping_appointments
          EXCLUDE USING gist (
            doctor_id WITH =,
            tsrange(start_at, end_at) WITH &&
          )
          WHERE (status != 'cancelled');
        SQL
      end

      dir.down do
        execute <<~SQL
          ALTER TABLE appointments
          DROP CONSTRAINT IF EXISTS no_overlapping_appointments;
        SQL
      end
    end
  end
end
