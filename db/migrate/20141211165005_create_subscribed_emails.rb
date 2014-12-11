class CreateSubscribedEmails < ActiveRecord::Migration
  def change
    create_table :subscribed_emails do |t|
      t.string :email
      t.belongs_to :user, index: true

      t.timestamps
    end

    add_index :subscribed_emails, :email, unique: true
  end
end
