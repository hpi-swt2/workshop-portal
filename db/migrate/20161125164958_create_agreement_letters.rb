class CreateAgreementLetters < ActiveRecord::Migration
  def change
    create_table :agreement_letters do |t|
      t.references :user, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true
      t.string :path, null: false

      t.timestamps null: false
    end
  end
end
