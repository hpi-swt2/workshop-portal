require './db/sample_data/agreement_letters'
require './db/sample_data/application_letters'
require './db/sample_data/events'
require './db/sample_data/profiles'
require './db/sample_data/requests'
require './db/sample_data/users'

def add_sample_data
  events = Hash.new

  events[:programmierkurs] = event_programmierkurs
  events[:mintcamp] = event_mintcamp
  events[:gongakrobatik] = event_gongakrobatik
  events[:batterie_akustik] = event_batterie_akustik
  events[:bachlorpodium] = event_bachlorpodium
  events[:past_deadline_event] = event_summer_camp

  # past events are not valid by definition, however we
  # would like to pretend to have some old ones
  event_bechersaeuberungsevent.save!(validate: false)

  users = Hash.new
  users[:pupil] = user_pupil
  users[:teacher] = user_teacher
  users[:applicant] = user_applicant
  users[:tobi] = user_tobi
  users[:lisa] = user_lisa
  users[:max] = user_max
  users[:coach] = user_coach
  users[:organizer] = user_organizer
  users[:hpi_admin] = user_admin

  profiles = Hash.new
  profiles[:pupil] = profile_pupil(users[:pupil])
  profiles[:teacher] = profile_teacher(users[:teacher])
  profiles[:applicant] = profile_applicant(users[:applicant])

  profiles[:tobi] = profile_tobi(users[:tobi])
  profiles[:tobi] = profile_tobi(users[:tobi])
  profiles[:lisa] = profile_lisa(users[:lisa])
  profiles[:max]  = profile_pupil_max(users[:max])
  profiles[:organizer] = profile_organizer(users[:organizer])
  profiles[:coach]  = profile_coach(users[:coach])
  profiles[:admin] = profile_admin(users[:hpi_admin])

  application_letters = Hash.new
  application_letters[:applicant_gongakrobatik] = application_letter_applicant_gongakrobatik(users[:applicant], events[:gongakrobatik])
  application_letters[:applicant_gongakrobatik_past_deadline] = application_letter_applicant_gongakrobatik(users[:applicant], events[:past_deadline_event])
  application_letters[:applicant_gongakrobatik_accepcted] = application_letter_applicant_gongakrobatik_accepted(users[:applicant], events[:past_deadline_event])
  application_letters[:applicant_gongakrobatik_rejected] = application_letter_applicant_gongakrobatik_rejected(users[:applicant], events[:past_deadline_event])
  application_letters[:applicant_gongakrobatik_max] = application_letter_applicant_gongakrobatik_accepted(users[:max], events[:past_deadline_event])
  application_letters[:applicant_gongakrobatik_karl] = application_letter_applicant_gongakrobatik_accepted(users[:pupil], events[:past_deadline_event])
  application_letters[:applicant_programmierkurs_lisa] = application_letter_applicant_programmierkurs_1(users[:lisa], events[:programmierkurs])
  application_letters[:applicant_programmierkurs_max] = application_letter_applicant_programmierkurs_2(users[:max], events[:programmierkurs])
  application_letters[:applicant_programmierkurs_tobi] = application_letter_applicant_programmierkurs_3(users[:tobi], events[:programmierkurs])

  application_letters[:applicant_mintcamp_lisa] = application_letter_applicant_programmierkurs_1(users[:lisa], events[:mintcamp])
  application_letters[:applicant_mintcamp_max] = application_letter_applicant_programmierkurs_2(users[:max], events[:mintcamp])
  application_letters[:applicant_mintcamp_tobi] = application_letter_applicant_programmierkurs_3(users[:tobi], events[:mintcamp])

  requests = Hash.new
  requests[:hardware_entwicklung] = request_hardware_entwicklung

  agreement_letters = Hash.new
  agreement_letters[:applicant_gongakrobatik] = agreement_letter_applicant_gongakrobatik(users[:applicant], events[:past_deadline_event])
  agreement_letters[:max_gongakrobatik] = agreement_letter_applicant_gongakrobatik(users[:max], events[:past_deadline_event])

  [events, users, profiles, application_letters, requests, agreement_letters].each do |models|
    save_models(models)
  end
  
  # set deadline to past to work around validation of application letters
  events[:past_deadline_event].application_deadline = Date.yesterday
  events[:past_deadline_event].save!
end

private
  def save_models(models)
    models.each do |key, model|
      model.save!
    end
  end
