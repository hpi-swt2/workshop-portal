require 'rails_helper'

RSpec.describe EmailsController, type: :controller do
  before :each do
    @event = FactoryGirl.create(:event)
    @user = FactoryGirl.create(:user, role: :organizer)
    sign_in @user
  end

  describe "GET #show" do
    it "renders email view" do
      get :show, event_id: @event.id
      expect(subject).to render_template(:email)
    end

    context "with valid accepted applications" do
      before :each do
        @application = FactoryGirl.create(:application_letter_accepted, event: @event, user: FactoryGirl.build(:user))
        @template = FactoryGirl.create(:email_template_accepted)
      end

      it "sets @email with the email of the accepted application" do
        get :show, event_id: @event.id, status: :accepted
        expect(assigns(:email)).to be_a(Email)
        expect(assigns(:email).recipients).to eq(@application.user.email)
      end

      it "sets @template with template for accepted emails" do
        get :show, event_id: @event.id, status: :accepted
        expect(assigns(:templates)).to eq([@template])
      end
    end

    context "with valid rejected applications" do
      before :each do
        @application = FactoryGirl.create(:application_letter_rejected, event: @event, user: FactoryGirl.build(:user))
        @template = FactoryGirl.create(:email_template_rejected)
      end

      it "sets @email with the email of the rejected application" do
        get :show, event_id: @event.id, status: :rejected
        expect(assigns(:email)).to be_a(Email)
        expect(assigns(:email).recipients).to eq(@application.user.email)
      end

      it "sets @template with template for rejected emails" do
        get :show, event_id: @event.id, status: :rejected
        expect(assigns(:templates)).to eq([@template])
      end
    end
  end

  describe "POST #submit" do
    context "with valid email pressing the send button" do
      before :each do
        @email = FactoryGirl.build(:email).attributes
      end

      it "sends an Email" do
        expect{
          post :submit, send: I18n.t('.emails.email_form.send'), event_id: @event.id, email: @email
        }.to change{ActionMailer::Base.deliveries.count}.by(1)
      end

      it "redirects to event view page" do
        post :submit, send: I18n.t('.emails.email_form.send'), event_id: @event.id, email: @email
        expect(subject).to redirect_to(@event)
      end

      it "shows success message" do
        post :submit, send: I18n.t('.emails.email_form.send'), event_id: @event.id, email: @email
        expect(flash[:notice]).to eq(I18n.t('.emails.submit.sending_successful'))
      end
    end

    context "with invalid email pressing the send button" do
      before :each do
        @email = FactoryGirl.build(:email, content: nil).attributes
      end

      it "does not send an Email" do
        expect{
          post :submit, send: I18n.t('.emails.email_form.send'), event_id: @event.id, email: @email
        }.to change{ActionMailer::Base.deliveries.count}.by(0)
      end

      it "shows the current email to make corrections" do
        post :submit, send: I18n.t('.emails.email_form.send'), event_id: @event.id, email: @email
        expect(subject).to render_template(:email)
      end

      it "shows error message" do
        post :submit, send: I18n.t('.emails.email_form.send'), event_id: @event.id, email: @email
        expect(flash[:alert]).to eq(I18n.t('.emails.submit.sending_failed'))
      end
    end

    context "with valid email pressing the save template button" do
      before :each do
        @email = FactoryGirl.build(:email).attributes
      end

      it "saves the current email as template" do
        expect {
          post :submit, save: I18n.t('.emails.email_form.save_template'), event_id: @event.id, email: @email, status: :accepted
        }.to change(EmailTemplate, :count).by(1)
      end

      it "shows success message" do
        post :submit, save: I18n.t('.emails.email_form.save_template'), event_id: @event.id, email: @email, status: :accepted
        expect(flash[:success]).to eq(I18n.t('.emails.submit.saving_successful'))
      end
    end

    context "with invalid email pressing the save template button" do
      before :each do
        @email = FactoryGirl.build(:email, content: '').attributes
      end

      it "does not save the current email as template" do
        expect {
          post :submit, save: I18n.t('.emails.email_form.save_template'), event_id: @event.id, email: @email, status: :accepted
        }.to change(EmailTemplate, :count).by(0)
      end

      it "shows error message" do
        post :submit, save: I18n.t('.emails.email_form.save_template'), event_id: @event.id, email: @email, status: :accepted
        expect(flash[:alert]).to eq(I18n.t('.emails.submit.saving_failed'))
      end
    end
  end
end