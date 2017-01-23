module ParticipantsOverviewHelper

  def sort_participants
    @participants.sort_by! {|p| @event.participant_group_for(p).send('group') } if params[:sort] == 'group'
    @participants.reverse! if params[:order] == 'descending'
  end

end
