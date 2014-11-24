module UsersHelper
  def settings_active_class(controller, controller_name, action_names = [])
    'active' if controller.controller_name == controller_name && action_names.include?(controller.action_name)
  end
end
