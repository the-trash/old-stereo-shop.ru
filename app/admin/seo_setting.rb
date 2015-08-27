ActiveAdmin.register SeoSetting do
  menu parent: I18n.t('active_admin.custom_menu.settings'), priority: 2
  permit_params :action_name, :controller_name, :seo_title,
                :seo_description, :keywords, :url

  index do
    selectable_column
    column :controller_name
    column :action_name
    column :seo_title
    actions
  end

  filter :id
  filter :controller_name
  filter :action_name
  filter :seo_title

  form do |f|
    
    f.inputs do
      
      f.inputs I18n.t('active_admin.views.main') do
        f.message_input I18n.t('active_admin.messages.seo_title_message')
        f.input :url
        f.input :controller_name
        f.input :action_name
      end

      f.inputs I18n.t('active_admin.views.meta') do
        f.input :seo_title
        f.input :seo_description
        f.input :keywords
      end
    end

    f.actions
  end
end
