# == Schema Information
#
# Table name: posts
#
#  id          :integer          not null, primary key
#  name        :string
#  body        :text
#  image       :string
#  url         :string
#  sources     :string
#  video       :string
#  cover       :string
#  state       :boolean
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string
#  views       :integer
#
# Indexes
#
#  index_posts_on_category_id  (category_id)
#

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
