require './db/sample_data/agreement_letters'
require './db/sample_data/application_letters'
require './db/sample_data/events'
require './db/sample_data/profiles'
require './db/sample_data/requests'
require './db/sample_data/users'


def add_sample_data
  events = Hash.new
  events[:bechersaeuberungsevent] = event_bechersaeuberungsevent
  events[:gongakrobatik] = event_gongakrobatik
  events[:batterie_akustik] = event_batterie_akustik
  events[:bachlorpodium] = event_bachlorpodium
  events[:past_deadline_event] = event_gongakrobatik
  events[:past_deadline_event].application_deadline = Date.yesterday

  users = Hash.new
  users[:pupil] = user_pupil
  users[:teacher] = user_teacher
  users[:applicant] = user_applicant

  profiles = Hash.new
  profiles[:pupil] = profile_pupil(users[:pupil])
  profiles[:teacher] = profile_teacher(users[:teacher])
  profiles[:applicant] = profile_applicant(users[:applicant])

  application_letters = Hash.new
  application_letters[:applicant_gongakrobatik] = application_letter_applicant_gongakrobatik(users[:applicant], events[:gongakrobatik])
  application_letters[:applicant_gongakrobatik_past_deadline] = application_letter_applicant_gongakrobatik(users[:applicant], events[:past_deadline_event])
  application_letters[:applicant_gongakrobatik_accepcted] = application_letter_applicant_gongakrobatik_accepted(users[:applicant], events[:gongakrobatik])
  application_letters[:applicant_gongakrobatik_rejected] = application_letter_applicant_gongakrobatik_rejected(users[:applicant], events[:gongakrobatik])

  requests = Hash.new
  requests[:hardware_entwicklung] = request_hardware_entwicklung(users[:teacher])

  agreement_letters = Hash.new
  agreement_letters[:applicant_gongakrobatik] = agreement_letter_applicant_gongakrobatik(users[:applicant], events[:gongakrobatik])

  [events, users, profiles, application_letters, requests, agreement_letters].each do |models|
    save_models(models)
  end
end

private
  def save_models(models)
    models.each do |key, model|
      model.save!
    end
  end
