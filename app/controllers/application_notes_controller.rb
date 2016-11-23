class ApplicationNotesController < ApplicationController
  def create
    @application_letter = ApplicationLetter.find(params[:application_letter_id])
    @application_note = @application_letter.application_notes.create(notes_params)
    if @application_note.valid?
      redirect_to application_letter_path(@application_letter)
    else
      render "application_letters/show"
    end
  end

  private
  def notes_params
    params.require(:application_note).permit(:note)
  end
end
