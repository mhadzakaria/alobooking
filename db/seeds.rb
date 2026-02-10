# Seed Doctors and Schedules
puts "Seeding Doctors..."
dr_strange = Doctor.create!(name: "Dr. Strange")
dr_who = Doctor.create!(name: "Dr. Who")

# Schedule: Mon-Fri 09:00 - 17:00
(1..5).each do |day|
  DoctorSchedule.create!(
    doctor: dr_strange,
    day_of_week: day,
    start_time: "09:00".to_time.in_time_zone,
    end_time: "17:00".to_time.in_time_zone
  )
end

# Schedule: Mon, Wed, Fri 10:00 - 14:00
[ 1, 3, 5 ].each do |day|
  DoctorSchedule.create!(
    doctor: dr_who,
    day_of_week: day,
    start_time: "10:00".to_time.in_time_zone,
    end_time: "14:00".to_time.in_time_zone
  )
end

puts "Seeding Patients..."
patient_zero = Patient.create!(name: "Patient Zero")
patient_one = Patient.create!(name: "Patient One")

puts "Seeding complete!"
