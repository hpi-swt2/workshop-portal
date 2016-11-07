# == Schema Information
#
# Table name: requests
#
#  id         :integer          not null, primary key
#  topics     :string
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Request < ActiveRecord::Base
  belongs_to :user
  
  validates :user, presence: true
end
