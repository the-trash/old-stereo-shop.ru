class AppErrorsController < ActionController::Base
  # Exception Notification markers
  def bug;        0/0; end
  def detect_403; 0/0; end
  def detect_404; 0/0; end
  def detect_422; 0/0; end
  def detect_500; 0/0; end
end