class Seat < ApplicationRecord
  belongs_to :user
  belongs_to :cinema

  enum timeslot: {
    _10am: 0,
    _2pm: 1,
    _6pm: 2,
    _10pm: 3
  }

  enum seat_number: {
    seat_0: 0,
    seat_1: 1,
    seat_2: 2,
    seat_3: 3,
    seat_4: 4,
    seat_5: 5,
    seat_6: 6,
    seat_7: 7,
    seat_8: 8,
    seat_9: 9,
  }
end
