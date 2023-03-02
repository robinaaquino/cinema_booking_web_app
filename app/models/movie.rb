class Movie < ApplicationRecord
  belongs_to :user
  belongs_to :cinema

  validates :name, presence: true, length: { maximum: 50 }
end