class ApplicationsPDF
  include Prawn::View
  Prawn::Font::AFM.hide_m17n_warning = true #consider adding TTF font

  # Generates a PDF file containing the details of every application for an event
  #
  # @param event [Event] the event whose applications are taken
  # @return [String] the generated PDF
  def self.generate(event)
    self.new(event).create.render
  end

  def initialize(event)
    @event = event
    @document = Prawn::Document.new(page_size: 'A4')
    @application_letters_count = @event.application_letters.count
  end

  # Adds all necessary data and formatting to the ApplicationsPDF
  #
  # @param none
  # @return [ApplicationsPDF] self
  def create
    create_overview
    @event.application_letters.each_with_index do |a,i|
      create_application_page(a, i)
    end
    self
  end

  private
    def create_overview
      text t("events.applicants_overview.title", title: @event.name), size: 20
      table description_table_data do
        cells.borders = []
        cells.padding = 3
        column(0).font_style = :bold
        column(0).align = :right
      end
      unless @event.application_letters.empty?
        table overview_table_data,
          header: 2, position: :center, row_colors: ["F9F9F9", "FFFFFF"] do
            cells.borders = []
            row(1).borders = [:bottom]
            row(1).font_style = :bold
            row(0).font_style = :bold
            row(0).padding = [5, 0, 5, 5] #minimize padding between first two rows
            row(1).padding = [0, 5, 5, 5]
          end
      end
    end

    def description_table_data
      data = [[Event.human_attribute_name(:description)+":", @event.description],
              [Event.human_attribute_name(:max_participants) + ":", @event.max_participants],
              [Event.human_attribute_name(:date_ranges) + ":", @event.date_ranges[0].to_s]]
      data += @event.date_ranges.drop(1).map { |d| ["", d.to_s] }
      data += [[Event.human_attribute_name(:organizer) + ":", @event.organizer]] if @event.organizer
      data += [[Event.human_attribute_name(:knowledge_level) + ":", @event.knowledge_level]] if @event.knowledge_level
      data += [[t("events.applications_pdf.free_places") + ":", @event.compute_free_places],
               [t("events.applications_pdf.occupied_places") + ":", @event.compute_occupied_places]]
    end

    def overview_table_data
      #line breaks lead to weird table formatting, so we create 2 header rows to fit all the text
      data = [["", "", "", t("events.applicants_overview.participations"), ""]]
      data += [[Profile.human_attribute_name(:name),
                Profile.human_attribute_name(:gender),
                t('application_letters.show.age_when_event_starts'),
                t("events.applicants_overview.accepted_rejected"),
                ApplicationLetter.human_attribute_name(:status)]]
      data += @event.application_letters.map do |a|
        [a.user.profile.name,
         t("profiles.genders.#{a.user.profile.gender}"),
         a.applicant_age_when_event_starts,
         "#{a.user.accepted_applications_count(@event)} / #{a.user.rejected_applications_count(@event)}",
         t("application_status.#{a.status}")]
      end
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
      table applicants_detail_data(application_letter) do
        cells.borders = []
        cells.padding = 3
        column(0).font_style = :bold
        column(0).align = :right
      end
      unless application_letter.annotation.nil?
        pad_top(20) { text "<u>#{t("application_letters.show.annotation_title")}</u>", inline_format: true}
        pad_top(5) { text application_letter.annotation }
      end
      pad_top(20) { text "<u>#{ApplicationLetter.human_attribute_name(:motivation)}</u>", inline_format: true}
      pad_top(5) { text application_letter.motivation }
      unless application_letter.application_notes.count == 0
        pad_top(15) do
          text "<u>#{ApplicationNote.model_name.human(count: application_letter.application_notes.count)}</u>", inline_format: true
          application_letter.application_notes.each do |note|
            pad_top(5) { text note.note }
          end
        end
      end
    end

    def applicants_detail_data(application_letter)
      [[Profile.human_attribute_name(:gender)+":", t("profiles.genders.#{application_letter.user.profile.gender}")],
       [t('application_letters.show.age_when_event_starts')+":", application_letter.applicant_age_when_event_starts],
       [User.human_attribute_name(:accepted_application_count)+":", application_letter.user.accepted_applications_count(@event)],
       [User.human_attribute_name(:rejected_application_count)+":", application_letter.user.rejected_applications_count(@event)],
       [Profile.human_attribute_name(:status)+":", t("application_status.#{application_letter.status}")]]
    end

    def create_main_header(application_letter)
        text t("application_letters.application_page.title", name: application_letter.user.profile.name), size: 20
        text t("application_letters.application_page.for", event: @event.name), size: 14
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
          text_box(t("events.applications_pdf.page") + " #{relative_page}/#{relative_last_page}",
                   at: [0, cursor],
                   align: :right)
          text ApplicationLetter.model_name.human + " #{index + 1}/#{@application_letters_count}"
        end
      end
    end

    def t(string, options = {})
      I18n.t(string, options)
    end
end
