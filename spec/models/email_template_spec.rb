# == Schema Information
#
# Table name: email_templates
#
#  id               :integer          not null, primary key
#  status           :integer(enum)    not null
#  hide_recipients  :boolean          not null
#  subject          :string           not null
#  content          :string           not null
#

require 'rails_helper'

describe EmailTemplate do

  it "can be created by email_template factory" do
    expect(FactoryGirl.build(:email_template)).to be_valid
  end

  it "can not be created without manditory fields" do
    expect(FactoryGirl.build(:email_template, subject: '', content:'')).to_not be_valid
  end

  it "accepts valid status values" do
    expect(FactoryGirl.build(:email_template, :acceptance)).to be_valid
    expect(FactoryGirl.build(:email_template, :rejection)).to be_valid
    expect(FactoryGirl.build(:email_template, :default)).to be_valid
  end
  
  it "rejects invalid status values" do
    expect { FactoryGirl.build(:email_template, status: :fubar) }.to raise_error(ArgumentError)
    expect { FactoryGirl.build(:email_template, status: 'fubar') }.to raise_error(ArgumentError)
    expect { FactoryGirl.build(:email_template, status: 42) }.to raise_error(ArgumentError)
  end

  it "returns correct templates by status", js: true do
    acceptance_template = FactoryGirl.create(:email_template, :acceptance)
    rejection_template = FactoryGirl.create(:email_template, :rejection)
    expect(EmailTemplate.with_status(:acceptance)).to eq([acceptance_template])
    expect(EmailTemplate.with_status(:rejection)).to eq([rejection_template])
  end
end
