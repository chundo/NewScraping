# == Schema Information
#
# Table name: categories
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  state       :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string
#

class Category < ApplicationRecord
    has_many :categorizations
    has_many :posts, through: :categorizations

    extend FriendlyId
    friendly_id :name, use: :slugged
end
