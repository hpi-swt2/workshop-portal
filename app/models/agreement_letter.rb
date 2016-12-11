# == Schema Information
#
# Table name: agreement_letters
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  event_id    :integer          not null
#  path        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class AgreementLetter < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  validates :user, :event, :path, presence: true
  MAX_SIZE = 300_000_000
  ALLOWED_MIMETYPE = "application/pdf"

  # Generates a unique filename for an AgreementLetter's file
  #
  # @raise [ArgumentError] if user or event are nil
  # @param none
  # @return [String] for the AgreementLetter's file name
  def filename
    event.nil? ? nil : "#{event.id}_#{user.id}.pdf"
  end

  def save_file(file)
    return false unless valid_file?(file)
    begin
      File.write(path, file.read, mode: 'wb')
      true
    rescue IOError
      self.destroy
      self.errors.add(:file, t('agreement_letters.write_failed'))
      false
    end
  end

  def set_path
    unless filename.nil?
      self.path = Rails.root.join('storage', 'agreement_letters', filename).to_s
    end
  end

  private
    def valid_file?(file)
      if !is_file?(file)
        errors.add(:file, I18n.t("not_a_file"))
        false
      elsif too_big?(file)
        errors.add(:file, I18n.t("too_big"))
        false
      elsif wrong_filetype?(file)
        errors.add(:file, I18n.t("wrong_filetype"))
        false
      else
        true
      end
    end
    
    def is_file?(file)
      file.respond_to?(:open) && file.respond_to?(:content_type) && file.respond_to?(:size)
    end

    def too_big?(file)
      file.size > MAX_SIZE
    end

    def wrong_filetype?(file)
      file.content_type != ALLOWED_MIMETYPE
    end
end
