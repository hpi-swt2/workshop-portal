class ParticipantsPDF
  include Prawn::View
  Prawn::Font::AFM.hide_m17n_warning = true #consider adding TTF font
 
  def self.generate(event)
    self.new(event).create.render
  end

  def initialize(event)
    @event = event
    @document = Prawn::Document.new(page_size: 'A4')
    @participants_count = @event.participants.count
    @participants_allergic_application_letters = []
    @participants_vegan_application_letters = []
    @participants_vegetarian_application_letters = []
    @participants_omnivorous_application_letters = []
    @event.participants.each do |p|

      letter = ApplicationLetter.find_by(user_id: p.id, event_id: @event.id)
      if !letter.nil?
        @participants_allergic_application_letters.push(letter) if letter.allergic
        @participants_vegetarian_application_letters.push(letter) if letter.vegetarian
        @participants_vegan_application_letters.push(letter) if letter.vegan
        @participants_omnivorous_application_letters.push(letter) if !letter.vegan && !letter.vegetarian
      end

    end
  end
  
  #
  # param none
  # return [ApplicationsPDF] self
  
  def create   
    create_summary
    self
  end

  private
    def create_summary
      text t("events.participants.print_title", title: @event.name), size: 20
      move_down 20
      text @event.date_ranges[0].to_s, size: 10
      move_down 20
      text t("events.participants.print_summary", count: @event.participants.count), size: 15
      
      if @participants_omnivorous_application_letters.any?
        text t("events.participants.print_summary_omnivorous", count: @participants_omnivorous_application_letters.count), size: 15
        @participants_omnivorous_application_letters.each do |p|
          move_down 5
          text p.user.name, size: 10
        end
      end

      move_down 20
      
      if @participants_vegan_application_letters.any?
        text t("events.participants.print_summary_vegan", count: @participants_vegan_application_letters.count), size: 15
        @participants_vegan_application_letters.each do |p|
          move_down 5
          text p.user.name, size: 10
        end
      end

      move_down 20

      if @participants_vegetarian_application_letters.any?
        text t("events.participants.print_summary_vegetarian", count: @participants_vegetarian_application_letters.count), size: 15
        @participants_vegetarian_application_letters.each do |p|
          move_down 5
          text p.user.name, size: 10
        end
      end

      move_down 20

      if @participants_count > 0
        text t('events.participants.print_summary_allergic'), size: 15
        @participants_allergic_application_letters.each do |p|
          output = p.user.name  
          output += " (" + t('activerecord.attributes.application_letter.vegan') + ")" if p.vegan
          output += " (" + t('activerecord.attributes.application_letter.vegetarian') + ")" if p.vegetarian
          output += " (" + t('activerecord.attributes.application_letter.omnivorous') + ")" if !p.vegetarian && !p.vegan
          output += " : " + p.allergies.to_s
          text output, size: 10
          move_down 5
        end
      end
    end

    def t(string, options = {})
      I18n.t(string, options)
    end
end