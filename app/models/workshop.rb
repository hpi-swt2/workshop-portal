# == Schema Information
#
# Table name: workshops
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :string
#  max_participants :integer
#  active           :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Workshop < ActiveRecord::Base
  has_many :application_letters
  
  validates :max_participants, numericality: { only_integer: true, greater_than: 0 }
end
