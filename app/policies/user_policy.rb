class UserPolicy < Struct.new(:current_user, :user)
  delegate :unsubscribe, to: :user

  def initialize(current_user, user)
    raise Pundit::NotAuthorizedError, I18n.t('you_should_be_logged_in') unless user
    super
  end

  def update?
    current_user == user
  end

  %w(index create show destroy).each do |method|
    alias_method :"#{method}?", :update?
  end

  def subscibe?
    unsubscribe
  end
end
