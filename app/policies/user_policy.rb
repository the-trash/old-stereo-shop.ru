class UserPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @current_user = current_user
    @user         = user
  end

  def update?
    current_user == user
  end

  %w(index create show destroy).each do |method|
    define_method :"#{method}?" do
      update?
    end
  end

  def subscibe?
    user.unsubscribe
  end
end
