class Seat < ApplicationRecord
  belongs_to :user
  belongs_to :cinema

  enum :timeslot, [:_10am, :_2pm, :_6pm, :_10pm]
  enum :seat_number, [:seat_0, :seat_1, :seat_2, :seat_3, :seat_4, :seat_5, :seat_6, :seat_7, :seat_8, :seat_9]
end
