class BadgesPDF
  include Prawn::View
  Prawn::Font::AFM.hide_m17n_warning = true #consider adding TTF font

  # Generates a PDF file containing the badges for each participant
  #
  # param event [Event] the event whose badges are created
  # return [String] the generated PDF
  def self.generate(event, names)
    self.new(event, names).create.render
  end

  def initialize(event, names)
    @event = event
    @names = names
    @document = Prawn::Document.new(page_size: 'A4')
    @badge_width = bounds.width / 2
    @badge_height = bounds.height / 5
  end

  def create
    @names.each_slice(10).each_with_index do | page_names, page_number |
      create_badge_page(page_names, page_number)
    end
    self
  end

  private
    # Create a page with maximum 10 badges
    def create_badge_page(names, page_number)
      # create no pagebreak for first page
      start_new_page if page_number > 0

      names.each_slice(2).with_index do |(left, right), row|
        create_badge(left, 0, bounds.height - row * @badge_height)
        create_badge(right, @badge_width, bounds.height - row * @badge_height) unless right.nil?
      end
    end

    def create_badge(name, x, y)
      stroke_rectangle [x, y], @badge_width, @badge_height
      text_box name,
        at: [x + @badge_width / 2 - 50 , y - 20],
        width: @badge_width - 100,
        height: @badge_height - 100,
        overflow: :shrink_to_fit
    end
end
