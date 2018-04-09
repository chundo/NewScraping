# == Schema Information
#
# Table name: covers
#
#  id         :integer          not null, primary key
#  name       :string
#  sumary     :string
#  image      :string
#  action_url :string
#  status     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Cover < ApplicationRecord
    mount_uploader :image, ImageUploader
end
