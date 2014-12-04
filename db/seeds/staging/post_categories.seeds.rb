after 'staging:users' do
  admin = AdminUser.first

  ['Новости', 'Полезная информация', 'Ваши вопросы'].each do |custom_title|
    PostCategory.create(admin_user: admin, title: custom_title)
  end
end
