class ApplicationsPDF
  include Prawn::View

  def self.generate(event)
    self.new(event).create.render
  end

  def initialize(event)
    @event = event
    @document = Prawn::Document.new(page_size: 'A4')
  end

  def create
    create_overview
    @event.application_letters.each { |a| create_application_page(a) }
    self
  end

  private
    def create_overview
      text "Application Overview for #{@event.name}", size: 20
    end

    def create_application_page(application_letter)
    end
end
