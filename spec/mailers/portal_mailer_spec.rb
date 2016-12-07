require "rails_helper"

RSpec.describe PortalMailer, type: :mailer do
    describe 'mail sending with direct addressing' do
      recipients = ['test@example.de', 'test2@example.de']
      subject = 'Subject'
      content = 'Awesome content'
      let(:mail) { described_class.generic_email(false, recipients, subject, content).deliver_now }

      it 'sets the subject' do
        expect(mail.subject).to eq(subject)
      end

      it 'sets the receiver email' do
        expect(mail.to).to eq(recipients)
      end

      it 'sets the receiver email' do
        expect(mail.bcc).to be_nil
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['workshop.portal@gmail.com'])
      end

      it 'sets the content' do
        expect(mail.body.encoded).to match(content)
      end
    end

    describe 'mail sending with bcc addressing' do
      recipients = ['test@example.de', 'test2@example.de']
      subject = 'Subject'
      content = 'Awesome content'
      let(:mail) { described_class.generic_email(true, recipients, subject, content).deliver_now }

      it 'sets the subject' do
        expect(mail.subject).to eq(subject)
      end

      it 'sets the receiver email' do
        expect(mail.to).to be_nil
      end

      it 'sets the receiver email' do
        expect(mail.bcc).to eq(recipients)
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['workshop.portal@gmail.com'])
      end

      it 'sets the content' do
        expect(mail.body.encoded).to match(content)
      end
    end
end
