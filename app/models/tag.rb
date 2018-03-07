class Tag < ApplicationRecord
  has_many :labeling
  has_many :posts, through: :labeling

  extend FriendlyId
  friendly_id :name, use: :slugged
end
