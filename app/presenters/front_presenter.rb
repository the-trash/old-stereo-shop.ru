class FrontPresenter < Struct.new(:current_user, :params)
  def meta
    {
      seo_title: I18n.t('seo_title', scope: [:meta, :default]),
      keywords: I18n.t('keywords', scope: [:meta, :default]),
      seo_description: I18n.t('seo_description', scope: [:meta, :default])
    }
  end

  def product_categories_with_photos
    product_categories_for_front.includes(:photos).arrange(order: :position)
  end

  def product_categories
    product_categories_for_front.arrange(order: :position)
  end

  def news_category
    find_post_category(title: I18n.t('news'))
  end

  def useful_information_category
    find_post_category(title: I18n.t('useful_information'))
  end

  def user_wishlist
    current_user ? current_user.wishes.group_by(&:product_id) : []
  end

  private

  def product_categories_for_front
    @product_categories_for_front ||= ProductCategory.for_front
  end

  def find_post_category(finder)
    PostCategory.find_by(finder)
  end
end
