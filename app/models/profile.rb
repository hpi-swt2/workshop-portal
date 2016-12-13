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
    self.birth_date >= 18.years.ago
  end

  # Returns the age of the user based on the current date
  #
  # @param none
  # @return [Int] for age as number of years
  def age
    now = Time.now.utc.to_date
    current_time_is_before_birthday = now.month > birth_date.month || (now.month == birth_date.month && now.day >= birth_date.day)
    return now.year - birth_date.year - (current_time_is_before_birthday ? 0 : 1)
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

  private
  def birthdate_not_in_future
    if birth_date.present? and birth_date > Date.current
      errors.add(:birth_date, I18n.t('profiles.validation.birthday_in_future'))
    end
  end
end
