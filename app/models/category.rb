class Category < ApplicationRecord
    has_many :categorizations
    has_many :posts, through: :categorizations

    extend FriendlyId
    friendly_id :name, use: :slugged
end
