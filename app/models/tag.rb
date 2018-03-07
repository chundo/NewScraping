class Tag < ApplicationRecord
  has_many :labeling
  has_many :posts, through: :labeling
end
