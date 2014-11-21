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

  def show?
    update?
  end

  %i(profile? mail? password? subscriptions?).each do |method|
    alias_method method, :show?
  end
end
