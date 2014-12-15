ActiveAdmin.register Newletter do
  menu parent: I18n.t('active_admin.custom_menu.posts'), priority: 4

  Newletter::states.each do |st, i|
    batch_action :"#{ st }" do |ids|
      Newletter.where(id: ids).update_all(state: i)
      redirect_to collection_path, notice: I18n.t('active_admin.views.batch_action', count: ids.size)
    end
  end

  batch_action :send_newletters do |ids|
    ids.each do |id|
      NewletterWorker.perform_async(id)
    end

    redirect_to collection_path, notice: I18n.t('active_admin.views.batch_action.newletters', count: ids.size)
  end

  actions :all, except: [:show, :destroy]

  permit_params :title, :description, :state, :admin_user_id, :post_category_id,
    :posts_count, :only_new_posts

  controller do
    def update
      update! do |format|
        format.html {
          redirect_to [:edit, :admin, resource], notice: I18n.t('active_admin.controller.actions.update')
        }
      end
    end

    protected

    def end_of_association_chain
      super.includes(:post_category)
    end
  end

  member_action :send_newletter, method: :get do
    msq = NewletterWorker.perform_async(params[:id]) ? 'success' : 'failure'
    redirect_to :back, notice: I18n.t(msq, scope: %i(active_admin views newletters send_newletter))
  end

  index do
    selectable_column
    column :id
    column :title
    column :post_category_id do |newletter|
      link_to newletter.post_category_title, [:edit, :admin, newletter.post_category]
    end
    column :settings do |newletter|
      new_posts = newletter.only_new_posts ? 'new_posts_yes' : 'new_posts_no'
      scope = %i(active_admin views newletters)
      subscription_type =
        [
          I18n.t('activerecord.attributes.newletter.subscription_type'),
          I18n.t("subscription_type.#{ newletter.subscription_type }", scope: scope)
          ].join(': ')

      raw(
        content_tag(:p, I18n.t('posts_count', count: newletter.posts_count, scope: scope)) +
        content_tag(:p, I18n.t(new_posts, scope: scope)) +
        content_tag(:p, subscription_type)
      )
    end

    actions do |newletter|
      link_to(I18n.t('active_admin.send_newletter'), [:send_newletter, :admin, newletter])
    end
  end

  filter :id
  filter :title
  filter :subscription_type, as: :select,
    collection: Newletter.subscription_types.map { |sub_type, i|
      [I18n.t("active_admin.views.newletters.subscription_type.#{ sub_type }"), i]
    }
  filter :admin_user, collection: AdminUser.for_select
  filter :created_at

  scope :all
  Newletter::STATES.each { |st| scope st }

  form do |f|
    f.inputs do
      f.inputs I18n.t('active_admin.views.main') do
        f.input :title
        f.input :description, as: :wysihtml5
        f.input :admin_user, as: :select2, collection: AdminUser.for_select, selected: resource.admin_user_id
        f.input :post_category, as: :select2, collection: PostCategory.for_select, selected: resource.post_category_id
        f.input :state, as: :select2, collection: resource_class.states.keys, selected: resource.state
      end

      f.inputs I18n.t('active_admin.views.settings') do
        f.input :posts_count
        f.input :only_new_posts, as: :boolean
        f.input :subscription_type, as: :select2,
          collection: Newletter.subscription_types.map { |sub_type, i|
            [I18n.t("active_admin.views.newletters.subscription_type.#{ sub_type }"), i]
          }, selected: resource.subscription_type, include_blank: false
      end
    end

    f.actions
  end
end
