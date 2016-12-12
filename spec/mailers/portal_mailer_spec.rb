require "rails_helper"

RSpec.describe PortalMailer, type: :mailer do
  let(:recipients) { ['test@example.de', 'test2@example.de'] }
  let(:reply_to) { ['test3@example.de'] }
  let(:subject) {'Subject'}
  let(:content) {'Awesome content'}

  describe 'mail sending with direct addressing' do
    let(:mail) { described_class.generic_email(false, recipients, reply_to, subject, content).deliver_now }

    it 'sets the subject' do
      expect(mail.subject).to eq(subject)
    end

    it 'sets the receiver email' do
      expect(mail.to).to eq(recipients)
    end

    it 'sets the bcc receiver email' do
      expect(mail.bcc).to be_nil
    end

    it 'sets the reply_to email' do
      expect(mail.reply_to).to eq(reply_to)
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['workshop.portal@gmail.com'])
    end

    it 'sets the content' do
      expect(mail.body.encoded).to match(content)
    end
  end

  describe 'mail sending with bcc addressing' do
    let(:mail) { described_class.generic_email(true, recipients, reply_to, subject, content).deliver_now }

    it 'sets the receiver email' do
      expect(mail.to).to be_nil
    end

    it 'sets the bcc receiver email' do
      expect(mail.bcc).to eq(recipients)
    end
  end
end
