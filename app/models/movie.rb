class Movie < ApplicationRecord
  belongs_to :user
  has_many :assignments, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
end