class Interpretation < ApplicationRecord
  belongs_to :dream

  validates :lang, presence: true
  validates :meaning, presence: true
  validates :jungian_perspective, presence: true
  validates :freudian_perspective, presence: true
  validates :loaded, inclusion: { in: [true, false] }
  validates :initiated, inclusion: { in: [true, false] }
end
