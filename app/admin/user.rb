ActiveAdmin.register User do
  menu parent: I18n.t('active_admin.custom_menu.users'), priority: 2

  actions :all, except: :show

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete('password')
        params[:user].delete('password_confirmation')
      end
      super
    end
  end

  permit_params :email, :birthday, :phone, :first_name, :last_name, :middle_name,
    :password, :password_confirmation

  index do
    selectable_column
    column "ФИО" do |user|
      [user.last_name, user.first_name, user.middle_name].join(' ')
    end
    column :email
    column :phone
    column "Зарегистрирован", :created_at
    actions
  end

  filter :email
  filter :phone
  filter :last_name
  filter :first_name
  # filter :first_name_or_last_name_or_middle_name_cont, as: :string, label: "ФИО"

  form do |f|
    f.inputs 'Details' do
      f.input :email
      f.input :birthday, as: :datepicker
      f.input :phone
    end

    f.inputs 'ФИО' do
      f.input :last_name
      f.input :first_name
      f.input :middle_name
    end

    f.inputs 'Пароль' do
      f.input :password
      f.input :password_confirmation
    end

    f.actions
  end
end
