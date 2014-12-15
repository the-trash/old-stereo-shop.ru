class NewletterWorker
  include Sidekiq::Worker

  sidekiq_options retry: 5, unique: true, queue: :critical

  def perform(newletter_id)
    subscribed_users = User.not_unsubscribe
    newletter        = Newletter.find(newletter_id)

    subscribed_users.send(:"is_#{ newletter.subscription_type }").find_each do |user|
      NewletterMailer.delay.newletter(user, newletter)
    end
  end
end
