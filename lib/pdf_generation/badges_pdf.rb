class BadgesPDF
  include Prawn::View
  Prawn::Font::AFM.hide_m17n_warning = true #consider adding TTF font
  X_PADDING = 25
  Y_PADDING = 20
  LOGO_HEIGHT = 50
  COLOR_HEIGHT = 20
  SCHOOL_HEIGHT_RATIO = 1.0/3
  MAX_NAME_FONT_SIZE = 28
  MAX_SCHOOL_FONT_SIZE = 16

  # Generates a PDF file containing the badges for each participant
  #
  # param event [Event] the event whose badges are created
  # return [String] the generated PDF
  def self.generate(event, participants, name_format, show_color, show_school, logo)
    self.new(event, participants, name_format, show_color, show_school, logo).create.render
  end

  def initialize(event, participants, name_format, show_color, show_school, logo)
    @event = event
    @participants = participants
    @name_format = name_format
    @show_color = show_color
    @show_school = show_school
    @logo = logo

    @document = Prawn::Document.new(page_size: 'A4')
    calculate_layout
  end

  def create
    @participants.each_slice(10).each_with_index do | page_participants, page_number |
      create_badge_page(page_participants, page_number)
    end
    self
  end

  private
    def calculate_layout
      @badge_width = bounds.width / 2
      @badge_height = bounds.height / 5

      v_space_left = @badge_height
      v_space_left -= Y_PADDING
      v_space_left -= LOGO_HEIGHT unless @logo.nil?
      v_space_left -= @show_color ? COLOR_HEIGHT : Y_PADDING
      if @show_school
        @school_height = v_space_left * SCHOOL_HEIGHT_RATIO
        v_space_left -= @school_height
      end
      @name_height = v_space_left
    end

    # Create a page with maximum 10 badges
    def create_badge_page(participants, page_number)
      # create no pagebreak for first page
      start_new_page if page_number > 0

      participants.each_slice(2).with_index do |(left, right), row|
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
        end

        create_name(participant, cursor)
        cursor -= @name_height

        if @show_school
          create_school(participant, cursor)
          cursor -= @school_height
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
      case @name_format
      when "first"
        name = participant.profile.first_name
      when "last"
        name = participant.profile.last_name
      else
        name = participant.profile.name
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

    def create_school(participant, y)
      text_box participant.profile.school,
        at: [X_PADDING, y],
        width: @badge_width - (X_PADDING * 2),
        align: :center,
        size: MAX_SCHOOL_FONT_SIZE,
        height: @school_height,
        overflow: :shrink_to_fit
    end

    def create_color(participant, y)
      #TODO use participant's group color
      fill_color "FFCC"
        fill_rectangle [0, y], @badge_width, COLOR_HEIGHT
      fill_color "0000"
    end
end
