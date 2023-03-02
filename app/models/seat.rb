class Seat < ApplicationRecord
  belongs_to :user
  belongs_to :cinema
end
