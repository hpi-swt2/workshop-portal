class ApplicationsPDF
  include Prawn::View
  Prawn::Font::AFM.hide_m17n_warning = true #consider adding TTF font

  def self.generate(event)
    self.new(event).create.render
  end

  def initialize(event)
    @event = event
    @document = Prawn::Document.new(page_size: 'A4')
    @application_letters_count = @event.application_letters.count
  end

  def create
    create_overview
    @event.application_letters.each_with_index { |a,i| create_application_page(a, i) }
    self
  end

  private
    def create_overview
      text "Application Overview for #{@event.name}", size: 20
      table description_table_data do
        cells.borders = []
        cells.padding = 3
        column(0).font_style = :bold
        column(0).align = :right
      end
      unless @event.application_letters.empty?
        table overview_table_data,
          header: true, width: 500, position: :center, row_colors: ["F9F9F9", "FFFFFF"] do
            cells.borders = []
            row(0).borders = [:bottom]
            row(0).font_style = :bold
          end
      end
    end

    def description_table_data
      data = [["Beschreibung:", @event.description],
              ["Maximale Teilnehmer:", @event.max_participants],
              ["Aktiv:", @event.active.to_s],
              ["Zeitspannen:", @event.date_ranges[0].to_s]]
      data += @event.date_ranges.drop(1).map { |d| ["", d.to_s] }
      data += [["Veranstalter:", @event.organizer]] if @event.organizer
      data += [["Kenntnisstand:", @event.knowledge_level]] if @event.knowledge_level
      data += [["Freie Plätze:", @event.compute_free_places],
               ["Belegte Plätze:", @event.compute_occupied_places]]
    end

    def overview_table_data
      data = [["Name", "Gender", "Age", "Accepted/rejected applications count", "Status"]]
      data += @event.application_letters.map { |a|
        [a.user.profile.name,
         a.user.profile.gender,
         a.user.profile.age,
         "#{a.user.accepted_applications_count(@event)} / #{a.user.rejected_applications_count(@event)}",
         a.status]}
    end

    def create_application_page(application_letter, index)
      start_new_page
      first_page = page_number
      create_main_header(application_letter)

      bounding_box([bounds.left, bounds.top - 50],
                   width: bounds.width,
                   height: bounds.height - 100) do
        create_application_page_content(application_letter)
      end

      create_headers(application_letter, first_page, page_number)
      create_footers(index, first_page, page_number)
    end

    def create_application_page_content(application_letter)
      pad_top(20) { text "Status: #{application_letter.status}" }
      pad(10) { text "Motivation letter:" }
      text application_letter.motivation
    end

    def create_main_header(application_letter)
        text "Application from #{application_letter.user.profile.name}", size: 20
        text "for #{application_letter.event.name}", size: 14
        stroke_horizontal_rule
    end

    def create_headers(application_letter, first_page, last_page)
      repeat(first_page + 1..last_page) do
        bounding_box [bounds.left, bounds.top], width: bounds.width do
          text @event.name
          text_box application_letter.user.profile.name, align: :right
          stroke_horizontal_rule
        end
      end
    end

    def create_footers(index, first_page, last_page)
      repeat(first_page..last_page, dynamic: true) do
        bounding_box [bounds.left, bounds.bottom + 25], width: bounds.width do
          relative_page = page_number - first_page + 1
          relative_last_page = last_page - first_page + 1
          stroke_horizontal_rule
          move_down(5)
          text_box("Page #{relative_page}/#{relative_last_page}",
                   at: [0, cursor],
                   align: :right)
          text "Application #{index + 1}/#{@application_letters_count}"
        end
      end
    end
end
