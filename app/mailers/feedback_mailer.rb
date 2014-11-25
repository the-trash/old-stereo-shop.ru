class FeedbackMailer < ActionMailer::Base
  default to: Setting.find_by(key: 'shop_feedback_email') || Settings.shop.feedback.to

  def feedback(params = {})
    @params = params
    subject = I18n.t("feedback_subject.#{ params[:subject] }").presence || Settings.shop.feedback.subject

    mail(from: params[:email], subject: subject)
  end
end
