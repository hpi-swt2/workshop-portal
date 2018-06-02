# == Schema Information
#
# Table name: participant_groups
#
#  id       :integer          not null, primary key
#  group    :integer          not null
#  event_id :integer
#  user_id  :integer
#
# Indexes
#
#  index_participant_groups_on_event_id  (event_id)
#  index_participant_groups_on_user_id   (user_id)
#

require 'rails_helper'

RSpec.describe ParticipantGroup, type: :model do
  
end
