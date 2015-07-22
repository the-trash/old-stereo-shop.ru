sitemap_helper = ShopSitemap.new

SitemapGenerator::Sitemap.default_host = "http://#{Settings.shop.default.host}"

SitemapGenerator::Sitemap.create do
  # Pages
  Page.published.find_each do |page|
    add page_path(page), lastmod: page.updated_at, priority: 0.75
  end

  # Brands
  add brands_path, priority: 0.5
  Brand.published.with_included_published_products.find_each do |brand|
    add brand_path(brand), lastmod: brand.updated_at, priority: 0.5
    sitemap_helper.add_links_with_pagination brand.products.size, Settings.pagination.products do |n|
      add brand_path(brand, page: n + 2)
    end
  end

  # PostCategories
  PostCategory.where(title: [I18n.t('news'), I18n.t('useful_information')]).each do |post_category|
    posts_category = post_category.with_posts

    if posts_category.any?
      add post_category_path(post_category), lastmod: post_category.updated_at, priority: 0.5
      sitemap_helper.add_links_with_pagination posts_category.size, Settings.pagination.posts do |n|
        add post_category_path(post_category, page: n + 2)
      end
      posts_category.find_each do |post|
        add post_path(post), lastmod: post.updated_at, priority: 0.5
      end
    end

    posts_category = nil
  end

  # ProductCategories
  ProductCategory.for_front.find_each do |product_category|
    published_products = product_category.products.published

    add product_category_path(product_category), lastmod: product_category.updated_at, priority: 0.5
    sitemap_helper.add_links_with_pagination published_products.size, Settings.pagination.products do |n|
      add product_category_path(product_category, page: n + 2)
    end

    published_products.find_each do |product|
      add product_path(product), lastmod: product.updated_at, priority: 0.5
    end

    published_products = nil
  end

  products = Product.published

  # Sale
  sale_products = products.with_discount
  sale_product_categories = ProductCategory.where(id: sale_products.pluck(:product_category_id).uniq)
  grouped_products_by_category = sale_products.group('products.product_category_id').size

  add sale_product_categories_path, priority: 0.5
  sitemap_helper.add_links_with_pagination sale_products.size, Settings.pagination.products do |n|
    add sale_product_categories_path(page: n + 2)
  end

  sale_product_categories.find_each do |sale_category|
    add sale_product_category_path(sale_category), lastmod: sale_category.updated_at, priority: 0.5
    sitemap_helper.add_links_with_pagination grouped_products_by_category[sale_category.id], Settings.pagination.products do |n|
      add sale_product_category_path(sale_category, page: n + 2)
    end
  end

  sale_products = nil
  sale_product_categories = nil
  grouped_products_by_category = nil

  # Products
  add products_path
  sitemap_helper.add_links_with_pagination products.size, Settings.pagination.products do |n|
    add products_path(page: n + 2)
  end

  products = nil
end
