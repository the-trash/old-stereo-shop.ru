class TestMailer < ActionMailer::Base

  # TestMailer.letter.deliver_now
  def letter
    mail to: 'zykin-ilya@ya.ru', from: 'ilya-zykin@stereo-shop.ru', subject: 'Test Letter'
  end
end