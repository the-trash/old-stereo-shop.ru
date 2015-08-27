class FrontPresenter < Struct.new(:current_user, :params)
  extend Memoist

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

  def safety
    Page.find_by title: I18n.t('safety')
  end
  memoize :safety

  def refund_of_money
    Page.find_by title: I18n.t('refund_of_money')
  end
  memoize :refund_of_money

  def show_news?
    news_category && news_category.with_posts.any?
  end
  memoize :show_news?

  def show_useful_information?
    useful_information_category && useful_information_category.with_posts.any?
  end
  memoize :show_useful_information?

  def show_post_categories?
    show_news? || show_useful_information?
  end
  memoize :show_post_categories?

  private

  def product_categories_for_front
    ProductCategory.for_front
  end
  memoize :product_categories_for_front

  def find_post_category(finder)
    PostCategory.find_by(finder)
  end
end
