# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Profile < ActiveRecord::Base
  POSSIBLE_GENDERS = ['male', 'female', 'other']
  
  belongs_to :user

  validates :user, presence: true
  validates_presence_of :first_name, :last_name, :gender, :birth_date, :school, :street_name, :zip_code, :city, :state, :country
  validate :birthdate_not_in_future
  validates_inclusion_of :gender, in: POSSIBLE_GENDERS


  # Returns true if the user is 18 years old or older
  #
  # @param none
  # @return [Boolean] whether the user is an adult
  def adult?()
    self.birth_date <= 18.years.ago
  end

  # Returns the age of the user based on the current date
  #
  # @param none
  # @return [Int] for age as number of years
  def age
    return age_at_time(Time.now)
  end

  # Returns the age of the user based on the given date
  #
  # @param none
  # @return [Int] for age as number of years
  def age_at_time (given_date)
    given_date_is_before_birth_date = given_date.month > birth_date.month || (given_date.month == birth_date.month && given_date.day >= birth_date.day)
    return given_date.year - birth_date.year - (given_date_is_before_birth_date ? 0 : 1)
  end

  # Returns the Full Name of the user
  #
  # @param none
  # @return [String] of name
  def name
    first_name + " " +  last_name
  end

  # Returns the address of the user
  # in Format: Street, Zip-Code City, State, Country
  #
  # @param none
  # @return [String] of address
  def address
    street_name + ", " + zip_code + " " +  city + ", " + state + ", " + country
  end

  # Returns a list of allowed parameters.
  #
  # @param none
  # @return [Symbol] List of parameters
  def self.allowed_params
    [:first_name, :last_name, :gender, :birth_date, :school, :street_name, :zip_code, :city, :state, :country, :graduates_school_in]
  end

  private
  def birthdate_not_in_future
    if birth_date.present? and birth_date > Date.current
      errors.add(:birth_date, I18n.t('profiles.validation.birthday_in_future'))
    end
  end
end
