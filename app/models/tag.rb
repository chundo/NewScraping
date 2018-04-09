# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string
#  post_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#
# Indexes
#
#  index_tags_on_post_id  (post_id)
#

class Tag < ApplicationRecord
  has_many :labeling
  has_many :posts, through: :labeling

  extend FriendlyId
  friendly_id :name, use: :slugged
end
