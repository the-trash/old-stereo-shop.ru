class OrderMailer < ActionMailer::Base
  # TODO remove default 'from' from other mailers and make this setting in application.rb
  default from: Setting.find_by(key: 'shop_mailer_default_from').try(:value) || Settings.shop.default.from

  def notify_admins order
    @order = order

    mail \
      to: OrderMailer.default_admin_emails,
      subject: make_subject(order),
      template_path: 'mailers/order_mailer/admin',
      template_name: order.state
  end

  def notify_user order
    @order = order

    mail \
      to: order.email,
      subject: make_subject(order),
      template_path: 'mailers/order_mailer/user',
      template_name: order.state
  end

  def self.default_admin_emails
    Setting.find_by(key: 'default_admin_emails').try(:value) || Settings.shop.order.admins
  end

  def in_one_click order
    @order = order

    mail \
      to: OrderMailer.default_admin_emails,
      subject: I18n.t('order_in_one_click')
  end

  private

  def make_subject order
    Setting.find_by(key: "subject_for_#{order.state}_order").try(:value) || Settings.shop.order.subject.try("#{order.state}")
  end
end
