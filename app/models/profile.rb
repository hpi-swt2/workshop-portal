# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  cv         :string
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Profile < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  validates_presence_of :first_name, :last_name, :gender, :birth_date, :email, :school, :street_name, :zip_code, :city, :state, :country

  # Returns the age of the user based on the current date
  #
  # @param none
  # @return [Int] for age as number of years
  def age
    now = Date.today
    now.year - birth_date.year - (birth_date.to_date.change(:year => now.year) > now ? 1 : 0)
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

end
