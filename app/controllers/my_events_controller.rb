class MyEventsController < ApplicationController

  # GET /my_events
  def index
    @application_letters = ApplicationLetter.where(user_id: current_user.id)
  end
end
