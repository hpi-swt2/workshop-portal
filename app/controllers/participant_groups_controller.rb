class ParticipantGroupsController < ApplicationController

  load_and_authorize_resource

  # PATCH/PUT /participant_group/1/group
  def update
    begin
      if @participant_group.update_attributes(participant_group_params)
        redirect_to :back, notice: I18n.t('participant_groups.update.successful')
      else
        redirect_to :back, alert: I18n.t('participant_groups.update.failed')
      end
    rescue ActionController::RedirectBackError
      redirect_to root_path
    end
  end

  private

    def participant_group_params
      params.require(:participant_group).permit(:group)
    end
end
