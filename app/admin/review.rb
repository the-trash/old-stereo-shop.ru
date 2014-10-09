ActiveAdmin.register Review do
  menu false

  belongs_to :product
  navigation_menu :default

  Review::states.each do |st, i|
    batch_action :"#{ st }" do |ids|
      Review.where(id: ids).update_all(state: i)
      redirect_to collection_path, notice: I18n.t('active_admin.views.batch_action', count: ids.size)
    end
  end

  actions :all, except: [:show, :destroy]

  controller do
    def update
      update! do |format|
        format.html {
          redirect_to [:edit, :admin, resource], notice: I18n.t('active_admin.controller.actions.update')
        }
      end
    end

    def scoped_collection
      @reviews ||= parent.reviews.includes(:rating)
    end
  end

  index do
    column :id
    column :pluses
    column :cons
    column :body do |review|
      content_tag(:p, review.body) +
      content_tag(:p, '', class: 'ratable read_only', data: { score: review.rating.score })
    end
    actions
  end

  config.filters = false

  scope :all
  Review::STATES.each { |st| scope st }

  form do |f|
    f.inputs do
      f.inputs I18n.t('active_admin.views.main') do
        f.input :pluses
        f.input :cons
        f.input :body, as: :wysihtml5
        f.input :state, as: :select2,
          collection: resource_class.states.keys, selected: resource.state
      end
    end

    f.actions
  end
end
