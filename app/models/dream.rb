class Dream < ApplicationRecord
  belongs_to :user

  has_many :interpretations, dependent: :destroy

  validates :description, presence: true
  validates :datedream, presence: true
  validates :quality, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  validates :hours, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
