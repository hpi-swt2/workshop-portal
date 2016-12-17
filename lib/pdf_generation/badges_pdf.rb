class BadgesPDF
  include Prawn::View
  Prawn::Font::AFM.hide_m17n_warning = true #consider adding TTF font
  X_PADDING = 25

  # Generates a PDF file containing the badges for each participant
  #
  # param event [Event] the event whose badges are created
  # return [String] the generated PDF
  def self.generate(event, participants, name_format, show_color, show_organization, logo)
    self.new(event, participants, name_format, show_color, show_organization, logo).create.render
  end

  def initialize(event, participants, name_format, show_color, show_organization, logo)
    @event = event
    @participants = participants
    @name_format = name_format
    @show_color = show_color
    @show_organization = show_organization
    @logo = logo

    @document = Prawn::Document.new(page_size: 'A4')
    @badge_width = bounds.width / 2
    @badge_height = bounds.height / 5
  end

  def create
    @participants.each_slice(10).each_with_index do | page_participants, page_number |
      create_badge_page(page_participants, page_number)
    end
    self
  end

  private
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
      case @name_format
      when "first"
        name = participant.profile.first_name
      when "last"
        name = participant.profile.last_name
      else
        name = participant.profile.name
      end

      stroke_rectangle [x, y], @badge_width, @badge_height
      text_box name,
        at: [x + X_PADDING, y - 20],
        width: @badge_width - (X_PADDING * 2),
        align: :center,
        size: 20,
        height: @badge_height - 100,
        overflow: :shrink_to_fit
    end
end
