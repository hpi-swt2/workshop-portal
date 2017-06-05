# == Schema Information
#
# Table name: events
#
#  id                         :integer          not null, primary key
#  name                       :string
#  description                :string
#  max_participants           :integer
#  date_ranges                :Collection
#  published                  :boolean
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  acceptances_have_been_sent :boolean
#  rejections_have_been_sent  :boolean
#  hidden                     :boolean
#

class Event < ActiveRecord::Base
  UNREASONABLY_LONG_DATE_SPAN = 300
  TRUNCATE_DESCRIPTION_TEXT_LENGTH = 250

  serialize :custom_application_fields, Array

  mount_uploader :custom_image, EventImageUploader

  has_many :application_letters
  has_many :agreement_letters
  has_many :participant_groups
  has_many :date_ranges
  accepts_nested_attributes_for :date_ranges
  validates_presence_of :name, :description, :application_deadline
  validates :max_participants, numericality: { only_integer: true, greater_than: 0 }
  validate :has_date_ranges
  validate :application_deadline_before_start_of_event
  validates :hidden, inclusion: { in: [true, false] }
  validates :hidden, exclusion: { in: [nil] }
  validates :published, inclusion: { in: [true, false] }
  validates :published, exclusion: { in: [nil] }
  validate :check_image_dimensions

  after_validation :update_image

  # if we uploaded a custom image, we want it to be synced to the "official"
  # image slot. only do this if we actually uploaded one and that image is valid
  def update_image
    if custom_image.filename.present? and errors[:custom_image].empty?
      self.image = '/' + custom_image.list_view.store_path
    end
  end

  # Use the image dimensions as returned from our uploader
  # to verify that the image has sufficient size
  def check_image_dimensions
    if custom_image.upload_width.present? &&
       custom_image.upload_height.present? &&
       (custom_image.upload_width < 200 || custom_image.upload_height < 155)
      errors.add(:custom_image, I18n.t("events.errors.image_too_small"))
      custom_image.remove!
    end
  end


  # Returns all participants for this event in following order:
  # 1. All participants that have to submit an letter of agreement but did not yet do so, ordered by name.
  # 2. All participants that have to submit an letter of agreement and did do so, ordered by name.
  # 3. All participants that do not have to submit an letter of agreement, ordered by name.
  #
  # @param none
  # @return [Array<User>] the event's participants in that order.
  def participants_by_agreement_letter
    @participants = self.participants
    @participants.sort { |x, y| self.compare_participants_by_agreement(x,y) }
  end

  # Checks if the participant selection is locked
  #
  # @param none
  # @return true if participant selection is locked
  def participant_selection_locked
    acceptances_have_been_sent || rejections_have_been_sent
  end

  # @return the minimum start_date over all date ranges
  def start_date
    (date_ranges.min { |a,b| a.start_date <=> b.start_date }).start_date
  end

  # @return the minimum end_date over all date ranges
  def end_date
    (date_ranges.max { |a,b| a.end_date <=> b.end_date }).end_date
  end

  # @return whether this event appears unreasonably long as defined by
  #         the corresponding constant
  def unreasonably_long
    end_date - start_date > Rails.configuration.unreasonably_long_event_time_span
  end

  # validation function on whether we have at least one date range
  def has_date_ranges
    errors.add(:date_ranges, I18n.t('date_range.errors.no_timespan')) if date_ranges.blank?
  end

  #validate that application deadline is before the start of the event
  def application_deadline_before_start_of_event
    errors.add(:application_deadline, I18n.t('events.errors.application_deadline_before_start_of_event')) if application_deadline.present? && !date_ranges.blank? && application_deadline > start_date
  end

  # Checks if the application deadline is over
  #
  # @param none
  # @return [Boolean] true if deadline is over
  def after_deadline?
    Date.current > application_deadline
  end

  # Returns the participants whose application for this Event has been accepted
  #
  # @param none
  # @return [Array<User>] the event's participants
  def participants
    accepted_applications = application_letters.where(status: ApplicationLetter.statuses[:accepted])
    accepted_applications.collect { |a| a.user }
  end

  # Returns the participant group for this event for a given participant (user). If it doesn't exist, it is created
  #
  # @param user [User] the user whose participant group we want
  # @return [ParticipantGroup] the user's participant group
  def participant_group_for(user)
    participant_group = self.participant_groups.find_by(user: user)
    if participant_group.nil?
      participant_group = ParticipantGroup.create(event: self, user: user, group: ParticipantGroup::GROUPS.default)
    end
    participant_group
  end

  # Returns the agreement letter a user submitted for this event
  #
  # @param user [User] the user whose agreement letter we want
  # @return [AgreementLetter, nil] the user's agreement letter or nil
  def agreement_letter_for(user)
    self.agreement_letters.where(user: user).take
  end

  # Returns whether all application_letters are classified or not
  #
  # @param none
  # @return [Boolean] if status of all application_letters is not pending
  def applications_classified?
    application_letters.all? { |application_letter| application_letter.status != 'pending' }
  end

  # Returns the tooltip used to help explain to the user why he can't send mails yet
  #
  # @return [String] the translated tooltip text or nil if mails can be sent
  def send_mails_tooltip
    if not applications_classified?
      I18n.t 'events.applicants_overview.unclassified_applications_left'
    elsif compute_free_places < 0
      I18n.t 'events.applicants_overview.maximum_number_of_participants_exeeded'
    else
      nil
    end
  end

  # Sets the status of all the event's application letters to accepted
  #
  # @param none
  # @return none
  def accept_all_application_letters
    application_letters.map { |application| application.update(status: :accepted) }
  end

  # Sets the status_notification_sent flag for all application letters of the given type
  #
  # @param status [Type] the desired application status the flag should be set for
  # @return none
  def set_status_notification_flag_for_applications_with_status(status)
    applications = application_letters.select {|application| application.status == status.to_s}
    applications.each do |application_letter|
      application_letter.update(status_notification_sent: true)
    end
  end

  # Returns an array of strings of all email addresses of applications with a given status type
  #
  # @param type [Type] the status type of the email addresses that will be returned
  # @return [Array<String>] Array of all email addresses of applications with given type, that don't have status_notification_sent set
  def email_addresses_of_type_without_notification_sent(type)
    applications = application_letters.where(status: ApplicationLetter.statuses[type], status_notification_sent: false)
    applications.collect { |a| a.user.email }
  end

  # Returns a new email to a set of participants
  #
  # @param all [Boolean] If set to true, addresses all participants
  # @param groups [Array<Integer>] The group-ids whoose members should be addressed
  # @param users [Array<Integer>] The user-ids which should be addressed
  # @return [Email] new email
  def generate_participants_email(all, groups, users)
    Email.new(
        :hide_recipients => false,
        :recipients => email_addresses_of_participants(all, groups, users),
        :reply_to => '',
        :subject => '',
        :content => ''
    )
  end

  # Returns a list of tuples containing all participant names and their id
  #
  # @return [Array<Array<String, Int>>]
  def participants_with_id
    participants.map{|participant| [participant.profile.name, participant.id]}
  end

  # Returns a list of group names and their id
  #
  # @return Array<Array<String, Int>>
  def groups_with_id
    existing = ParticipantGroup::GROUPS.select do |group_id,_|
      group_id != 0 && participant_groups.where(:group => group_id).any?
    end
    existing.map do |group_id,color_code|
      [I18n.t("participant_groups.options.#{color_code}"), group_id]
    end
  end

  # Returns the number of free places of the event, this value may be negative
  #
  # @param none
  # @return [Int] for number of free places available
  def compute_free_places
    max_participants - compute_occupied_places
  end

  # Returns the number of already occupied places of the event
  #
  # @param none
  # @return [Int] for number of occupied places
  def compute_occupied_places
    application_letters.where(status: ApplicationLetter.statuses[:accepted]).count
  end

  # Returns whether there are applications of given state with no status notification sent of the event
  #
  # @param [Symbol] status
  # @return [Boolean] true if there are participants of given state without status notification sent
  def has_participants_without_status_notification?(status)
    application_letters.exists?(status: ApplicationLetter.statuses[status], status_notification_sent: false)
  end

  # Returns the current state of the event (draft-, application-, selection- and execution-phase)
  #
  # @param none
  # @return [Symbol] state
  def phase
    return :draft if !published
    return :application if published && !after_deadline?
    return :selection if published && after_deadline? && !(acceptances_have_been_sent && rejections_have_been_sent)
    return :execution if published && after_deadline? && acceptances_have_been_sent && rejections_have_been_sent
  end

  # Returns whether the event has application letters with status alternative
  #
  # @param none
  # @return [Boolean] true, if any exists, false otherwise
  def has_alternative_application_letters?
    application_letters.any? { |application| application.status == 'alternative' }
  end

  # Returns a label listing the number of days to the deadline if
  # it's <= 7 days to go. Otherwise returns nil.
  #
  # @return string containing the label or nil
  def application_deadline_label
    days = (application_deadline - Date.current).to_i
    return I18n.t('events.notices.deadline_approaching', count: days) if days <= 7 and days >= 0
  end

  # Uses the start date to determine whether or not this event is in the past (or more
  # precisely, in the past or currently running)
  #
  # @return boolean if it's in the past
  def is_past
    return start_date < Date.current
  end

  # Returns a label that describes the duration of the event in days,
  # also mentioning whether or not the event happens on consecutive
  # days.
  #
  # @return the duration label or nil
  def duration_label
    # gotta add 1 since from Sunday to Monday is on two days, but only
    # a difference of a single day
    days = (end_date - start_date).to_i + 1

    if date_ranges.size > 1
      I18n.t('events.notices.time_span_non_consecutive', count: days)
    else
      I18n.t('events.notices.time_span_consecutive', count: days)
    end
  end

  # Returns the application letters ordered by either "email", "first_name", "last_name", "birth_date"
  # either "asc" (ascending) or "desc" (descending).
  #
  # @param field [String] the field that should be used to order
  # @param order_by [String] the order that should be used
  # @return [ApplicationLetter] the application letters found
  def application_letters_ordered(field, order_by)
    field = case field
              when "email"
                "users.email"
              when "birth_date", "first_name", "last_name"
                "profiles." + field
              else
                "users.email"
            end
    order_by = 'asc' unless order_by == 'asc' || order_by == 'desc'
    application_letters.joins(user: :profile).order(field + ' ' + order_by)
  end

  # Make sure any assignment coming from the controller
  # replaces all date ranges instead of adding new ones
  def date_ranges_attributes=(*args)
    self.date_ranges.clear
    super(*args)
  end

  # Gets the path of the event in the material storage
  #
  # @return [String] path in the material storage
  def material_path
    File.join("storage/materials/", self.id.to_s + "_event")
  end

  # Make sure we add errors from our date_range children
  # to the base event object for displaying
  validate do |event|
    event.date_ranges.each do |date_range|
      next if date_range.valid?
      date_range.errors.full_messages.each do |msg|
        errors.add :date_ranges, msg unless errors[:date_ranges].include? msg
      end
    end
  end

  scope :draft_is, ->(status) { where("not published = ?", status) }
  scope :hidden_is, ->(status) { where("hidden = ?", status) }
  scope :with_date_ranges, -> { joins(:date_ranges).group('events.id').order('MIN(start_date)') }
  scope :future, -> { with_date_ranges.having('date(MAX(end_date)) > ?', Time.zone.yesterday.end_of_day) }
  scope :past, -> { with_date_ranges.having('date(MAX(end_date)) < ?', Time.zone.now.end_of_day) }

  # Returns events sorted by start date, returning only public ones
  # if requested
  #
  # @param limit Maximum number of events to return
  # @param only_public Set to true to not include drafts and hidden events
  # @return List of events
  def self.sorted_by_start_date(only_public)
    (only_public ? Event.draft_is(false).where(hidden: false) : Event.all)
      .sort_by(&:start_date)
  end

  # Returns the date_ranges of the event in ical format
  #
  # @param none
  # @return ical attachment of date_ranges
  def get_ical_attachment
    cal = Icalendar::Calendar.new
    for date_range in date_ranges do
      cal.event do |e|
        e.dtstart     = date_range.start_date
        e.dtend       = date_range.end_date
        e.summary     = name
        e.description = description
        e.url         = Rails.application.routes.url_helpers.event_path(self)
      end
    end

    {name: (I18n.t 'emails.ical_attachment'), content: cal.to_ical}
  end

  protected

  # Returns a string of all email addresses of accepted applications
  #
  # @param none
  # @return [String] Concatenation of all email addresses of accepted applications, seperated by ','
  def email_addresses_of_accepted_applicants
    participants.collect { |user| user.email }.join(',')
  end

  # Returns a list of email addresses of all participants that are in one of the given groups
  #
  # @return [String]
  def email_addresses_of_groups(groups)
    if groups.nil?
      groups = []
    end
    groups.reduce([]) {|addresses, group| addresses + email_addresses_of_group(group)}.uniq
  end

  # Returns a list of email addresses of all participants that are in this exact group
  #
  # @return [String]
  def email_addresses_of_group(group)
    participant_groups.where(:group => group).map {|participant_group| participant_group.user.email}
  end

  # Returns a list of email addresses
  def email_addresses_of_users(users)
    user = User.where(id: users)
    user.map{ |user| user.email }
  end

  # Returns all email addresses of user that fit the given criteria
  #
  # @param all [Boolean] If set to true, return addresses of all participants
  # @param groups [Array<Integer>] The group-ids whoose members-addresses should be looked up
  # @param users [Array<Integer>] The user-ids whoose addresses should be returned
  # @return [String] list of email addresses
  def email_addresses_of_participants(all, groups, users)
    if all
      email_addresses_of_accepted_applicants
    else
      (email_addresses_of_groups(groups) + email_addresses_of_users(users)).uniq.join(',')
    end
  end

  # Compares two participants to achieve following order:
  # 1. All participants that have to submit an letter of agreement but did not yet do so, ordered by email.
  # 2. All participants that have to submit an letter of agreement and did do so, ordered by email.
  # 3. All participants that do not have to submit an letter of agreement, ordered by email.
  def compare_participants_by_agreement(participant1, participant2)
    unless participant1.requires_agreement_letter_for_event?(self)
      unless participant2.requires_agreement_letter_for_event?(self)
        return participant1.email <=> participant2.email
      end
      return 1
    end
    unless participant2.requires_agreement_letter_for_event?(self)
      return -1
    end
    if participant1.agreement_letter_for_event?(self)
      if participant2.agreement_letter_for_event?(self)
        return participant1.email <=> participant2.email
      end
      return 1
    end
    if participant2.agreement_letter_for_event?(self)
      return -1
    end
    return participant1.email <=> participant2.email
  end

end
