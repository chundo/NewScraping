class Post < ApplicationRecord
  has_many :categorizations
  has_many :categories, through: :categorizations
  has_many :labeling
  has_many :tags, through: :labeling
  
  extend FriendlyId
  friendly_id :name, use: :slugged
end
