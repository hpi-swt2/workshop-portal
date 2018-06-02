class ParticipantGroupsController < ApplicationController
  load_and_authorize_resource

  # PATCH/PUT /participant_group/1/group
  def update
    if @participant_group.update_attributes(participant_group_params)
      redirect_back(fallback_location: root_path, notice: I18n.t('participant_groups.update.successful'))
    else
      redirect_back(fallback_location: root_path, alert: I18n.t('participant_groups.update.failed'))
    end
  end

  private

  def participant_group_params
    params.require(:participant_group).permit(:group)
  end
end
