class FeedbackMailer < ActionMailer::Base
  default to: Setting.find_by(key: 'shop_feedback_email').try(:value) || Settings.shop.feedback.to

  def feedback(params = {})
    @params = params
    subject = I18n.t("feedback_subject.#{ params[:subject] }").presence || Settings.shop.feedback.subject

    mail(from: params[:email], subject: subject)
  end

  def call_me params = {}
    @params = params
    subject = I18n.t('feedback_subject.call_me')

    mail from: Settings.shop.feedback.to, subject: subject
  end
end
