require "rails_helper"

RSpec.describe Mailer, type: :service do
  let(:recipients_string) { 'test@example.de, test2@example.de' }
  let(:recipients_array) { recipients_string.lines(',') }

  let(:reply_to) { ['test3@example.de'] }
  let(:subject) {'Subject'}
  let(:content) {'Awesome content'}

  describe 'mail sending with direct addressing' do
    it 'sends right amount of emails with an array of recipients given' do
      expect{Mailer.send_generic_email(false, recipients_array, reply_to, subject, content)}.to change{ActionMailer::Base.deliveries.count}.by(1)
    end

    it 'sends right amount of emails with a string of recipients given' do
      expect{Mailer.send_generic_email(false, recipients_string, reply_to, subject, content)}.to change{ActionMailer::Base.deliveries.count}.by(1)
    end

    it 'has the correct number of recipients with an array of recipients given' do
      Mailer.send_generic_email(false, recipients_array, reply_to, subject, content)
      expect(ActionMailer::Base.deliveries.last.to.count).to eq(recipients_array.count)
    end

    it 'has the correct number of recipients with a string of recipients given' do
      Mailer.send_generic_email(false, recipients_string, reply_to, subject, content)
      expect(ActionMailer::Base.deliveries.last.to.count).to eq(recipients_array.count)
    end
  end

  describe 'mail sending with indirect addressing' do
    it 'sends right amount of emails with an array of recipients given' do
      expect{Mailer.send_generic_email(true, recipients_array, reply_to, subject, content)}.to change{ActionMailer::Base.deliveries.count}.by(recipients_array.count)
    end

    it 'sends right amount of emails with a string of recipients given' do
      expect{Mailer.send_generic_email(true, recipients_string, reply_to, subject, content)}.to change{ActionMailer::Base.deliveries.count}.by(recipients_array.count)
    end

    it 'hides recipients from each other with an array of recipients given' do
      Mailer.send_generic_email(true, recipients_array, reply_to, subject, content)
      ActionMailer::Base.deliveries.last(recipients_array.count).each do |delivery|
        expect(delivery.to.count).to eq(1)
      end
    end

    it 'hides recipients from each other with a string of recipients given' do
      Mailer.send_generic_email(true, recipients_string, reply_to, subject, content)
      ActionMailer::Base.deliveries.last(recipients_array.count).each do |delivery|
        expect(delivery.to.count).to eq(1)
      end
    end
  end
end
