class UserPolicy
  attr_reader :user, :obj_user

  def initialize(user, obj_user)
    @user     = user
    @obj_user = obj_user
  end

  def update?
    user
  end

  def edit?
    update?
  end
end
