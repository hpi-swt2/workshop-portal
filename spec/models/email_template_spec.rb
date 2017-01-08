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

  it "can be created by user factory" do
    expect(FactoryGirl.build(:email_template)).to be_valid
  end

  it "can not be created without manditory fields" do
    expect(FactoryGirl.build(:email_template, subject: '', content:'')).to_not be_valid
  end

  it "accepts valid status values" do
    expect(FactoryGirl.build(:email_template, status: :accepted)).to be_valid
    expect(FactoryGirl.build(:email_template, status: :rejected)).to be_valid
  end
end