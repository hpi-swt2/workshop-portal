class BadgesPDF
  include Prawn::View
  Prawn::Font::AFM.hide_m17n_warning = true

  # Constants for tweaking the layout
  X_PADDING = 25 # left and right padding for text
  Y_PADDING = 20 # top and bottom padding (if show_color, no bottom padding is used)
  LOGO_HEIGHT = 50 # height of the logo (only if logo)
  COLOR_HEIGHT = 20 # height of the colored rectangle (only if show_color)
  ORGANISATION_HEIGHT_RATIO = 1.0 / 3 # fraction of the space for text that is occupied by the organisation (only if show_organisation). The remaining space is occupied by the name.
  MAX_NAME_FONT_SIZE = 28 # font size for the name, is automatically lowered if the text does not fit
  MAX_ORGANISATION_FONT_SIZE = 16 # font size for the organisation, is automatically lowered if the text does not fit
  LINE_SPACING = 5 # empty space above text
  ROW_NUMBER = 5 # number of rows of badges
  COLUMN_NUMBER = 2 # number of columns of badges

  # Generates a PDF file containing the badges for each participant
  #
  # @param event [Event] the event whose badges are created
  # @param participants [Array<User>] the users whose badges are created
  # @param name_format [String, nil] the format with which the name is added, "first", "last" or "full"
  # @param show_color [Boolean, nil] whether to add a rectangle of the user's group color
  # @param show_organisation [Boolean, nil] whether to add the organisation of the user's organisation
  # @param logo [ActionDispatch::Http::UploadedFile, nil] the logo to add
  # @return [String] the generated PDF
  def self.generate(event, participants, name_format, show_color, show_organisation, logo)
    new(event, participants, name_format, show_color, show_organisation, logo).create.render
  end

  def initialize(event, participants, name_format, show_color, show_organisation, logo)
    @event = event
    @participants = participants
    @name_format = name_format || 'full'
    @show_color = show_color || false
    @show_organisation = show_organisation || false
    @logo = logo

    @document = Prawn::Document.new(page_size: 'A4')
    calculate_layout
  end

  # Adds all necessary data and formatting to the BadgesPDF
  #
  # @param none
  # @return [BadgesPDF] self
  def create
    badges_per_page = COLUMN_NUMBER * ROW_NUMBER
    @participants.each_slice(badges_per_page).each_with_index do |page_participants, page_number|
      create_badge_page(page_participants, page_number)
    end
    self
  end

  private

  def calculate_layout
    @badge_width = bounds.width / COLUMN_NUMBER
    @badge_height = bounds.height / ROW_NUMBER

    v_space_left = @badge_height
    v_space_left -= Y_PADDING
    if @logo
      v_space_left -= LOGO_HEIGHT
      v_space_left -= LINE_SPACING
    end
    v_space_left -= @show_color ? COLOR_HEIGHT : Y_PADDING

    if @show_organisation
      @organisation_height = v_space_left * ORGANISATION_HEIGHT_RATIO
      v_space_left -= @organisation_height
      v_space_left -= LINE_SPACING
    end
    @name_height = v_space_left
  end

  # Create a page with maximum 10 badges
  def create_badge_page(participants, page_number)
    # create no pagebreak for first page
    start_new_page if page_number > 0

    participants.each_slice(COLUMN_NUMBER).with_index do |(left, right), row|
      create_badge(left, 0, bounds.height - row * @badge_height)
      create_badge(right, @badge_width, bounds.height - row * @badge_height) unless right.nil?
    end
  end

  def create_badge(participant, x, y)
    bounding_box [x, y], width: @badge_width, height: @badge_height do
      cursor = bounds.top
      cursor -= Y_PADDING

      if @logo
        create_logo(cursor)
        cursor -= LOGO_HEIGHT
        cursor -= LINE_SPACING
      end

      create_name(participant, cursor)
      cursor -= @name_height

      if @show_organisation
        cursor -= LINE_SPACING
        create_organisation(participant, cursor)
        cursor -= @organisation_height
      end

      create_color(participant, cursor) if @show_color
      stroke_bounds
    end
  end

  def create_logo(y)
    image @logo,
          height: LOGO_HEIGHT,
          position: :center,
          vposition: bounds.top - y
  end

  def create_name(participant, y)
    name = case @name_format
           when 'first'
             participant.profile.first_name
           when 'last'
             participant.profile.last_name
           else
             participant.profile.name
           end

    text_box name,
             at: [X_PADDING, y],
             width: @badge_width - (X_PADDING * 2),
             height: @name_height,
             align: :center,
             valign: :center,
             size: MAX_NAME_FONT_SIZE,
             overflow: :shrink_to_fit
  end

  def create_organisation(participant, y)
    organisation = ApplicationLetter.where(event: @event, user: participant).first.organisation
    text_box organisation,
             at: [X_PADDING, y],
             width: @badge_width - (X_PADDING * 2),
             align: :center,
             size: MAX_ORGANISATION_FONT_SIZE,
             height: @organisation_height,
             overflow: :shrink_to_fit
  end

  def create_color(participant, y)
    color = ParticipantGroup::GROUPS[@event.participant_group_for(participant).group]
    color = 'FFFFFF' if color == '0' # in case the color is "none"
    fill_color color
    fill_rectangle [0, y], @badge_width, COLOR_HEIGHT
    fill_color '000000'
  end
end
