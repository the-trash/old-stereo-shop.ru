Rails.application.config.after_initialize do
  $settings =
    begin
      Setting.make_hash
    rescue
      {}
    end
end