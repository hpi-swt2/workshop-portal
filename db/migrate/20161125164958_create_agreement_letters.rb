class CreateAgreementLetters < ActiveRecord::Migration[4.2]
  def change
    create_table :agreement_letters do |t|
      t.references :user, index: true, foreign_key: true, null:false
      t.references :event, index: true, foreign_key: true, null:false
      t.string :path, null: false

      t.timestamps null: false
    end
  end
end
