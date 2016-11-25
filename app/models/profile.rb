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

  def age
    now = Date.today
    now.year - birth_date.year - (birth_date.to_date.change(:year => now.year) > now ? 1 : 0)
  end

  def name
    first_name + " " +  last_name
  end

  def self.human_attribute_name(*args)
    case args[0].to_s
      when "name"
        return "Name"
      when "gender"
        return "Geschlecht"
      when "age"
        return "Alter"
      else
        super
    end
  end
end