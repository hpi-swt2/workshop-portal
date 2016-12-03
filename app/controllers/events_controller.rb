class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  def index
    @events = Event.all
  end

  # GET /events/1
  def show
    @free_places = @event.compute_free_places
    @occupied_places = @event.compute_occupied_places
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @event = Event.new(event_params)

    @event.date_ranges = date_range_params

    if @event.save
      redirect_to @event, notice: 'Event wurde erstellt.'
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    attrs = event_params

    if params[:date_ranges]
      attrs[:date_ranges] = date_range_params
    end

    if @event.update(attrs)
      redirect_to @event, notice: 'Event wurde aktualisiert.'
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    redirect_to events_url, notice: 'Event wurde gelöscht.'
  end

  # GET /events/1/participants
  def participants
    @event = Event.find(params[:id])
    @participants = @event.participants
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # We receive start_date/end_date pairs in a weird format because forms
    # are limited in the way they can arrange data for us. So we translate
    # pairs of { start_date: [{day, month, year}, {day, month, year}], end_date: [...] }
    # to the expected format [{start_date, end_date}, ...]
    #
    # @return array of start_date, end_date pairs
    def date_range_params
      dateRanges = params[:date_ranges] || {start_date: [], end_date: []}

      dateRanges[:start_date].zip(dateRanges[:end_date]).map do |s, e|
        DateRange.new(start_date: date_from_form(s), end_date: date_from_form(e))
      end
    end

    # Extract date object from given date_info as returned by a form
    #
    # @param date_info [Hash] hash containing year, month and day keys
    # @return [Date] the extracted date
    def date_from_form(date_info)
      Date.new(date_info[:year].to_i, date_info[:month].to_i, date_info[:day].to_i)
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:name, :description, :max_participants, :active, :kind, :organizer, :knowledge_level)
    end
end
