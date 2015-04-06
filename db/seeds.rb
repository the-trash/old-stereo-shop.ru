require 'spec/support/factory_girl_sequences'

# default settings
settings = [
  ['shop_name', 'Stereo Shop', 'Название магазина'],
  ['shop_phone', '+7 (812) 499-49-20', 'Телефон магазина'],
  ['shop_work_start', '10:00', 'Начало работы'],
  ['shop_work_end', '18:00', 'Конец работы'],
  ['delivery_cities', 'Санкт-Петербург,Москва', 'Города доставки']
]

settings.each do |setting|
  Setting.create(
    key: setting[0],
    value: setting[1],
    description: setting[2],
    group: (setting[3] || 'Основные')
  ) unless Setting.find_by_key(setting[0]).present?
end

require 'fileutils'
print '.'.green if FileUtils.rm_rf "#{Rails.root}/public/uploads/"
