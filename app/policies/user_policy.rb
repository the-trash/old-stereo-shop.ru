class UserPolicy
  attr_reader :user

  def initialize(user, obj_user)
    @user = user
  end

  def update?
    user
  end

  def edit?
    update?
  end
end
