# == Schema Information
#
# Table name: labelings
#
#  id         :integer          not null, primary key
#  tag_id     :integer
#  post_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_labelings_on_post_id  (post_id)
#  index_labelings_on_tag_id   (tag_id)
#

class Labeling < ApplicationRecord
  belongs_to :tag
  belongs_to :post
end
