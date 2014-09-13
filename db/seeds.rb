# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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
