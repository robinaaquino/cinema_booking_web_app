class Cinema < ApplicationRecord
  belongs_to :user
  has_many :movies, dependent: :destroy
  has_many :seats, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
end
