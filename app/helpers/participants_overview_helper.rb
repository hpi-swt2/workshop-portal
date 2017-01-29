module ParticipantsOverviewHelper

  def sort_participants
    @participants.sort_by! {|p| @event.participant_group_for(p).send('group') } if params[:sort] == 'group'
    if params[:sort] == 'eating-habits'
        
      @participants.sort! do |a,b| 
        a = ApplicationLetter.find_by(user_id: a.id, event_id: @event.id)
        b = ApplicationLetter.find_by(user_id: b.id, event_id: @event.id)
        a.get_eating_habit_state <=> b.get_eating_habit_state     
      end
    end
    
    @participants.reverse! if params[:order] == 'descending'
  end

end
