after 'development:stores' do
  require 'fileutils'
  print '.'.green if FileUtils.rm_rf "#{Rails.root}/public/uploads/"

  products = Product.published
  suckr    = ImageSuckr::GoogleSuckr.new
  product_pictures =
    [].tap do |a|
      rand(20..30).times do |n|
        a << suckr.get_image_url({ q: 'stereo&product' })
      end
    end

  progressbar_photo_for_products =
    ProgressBar.create({
      title: 'Create photos for products',
      total: products.size,
      format: '%t %B %p%% %e'
    })

  products.find_each do |product|
    rand(2..4).times do |n|
        tries ||= 3
      begin
        Photo.create({
          photoable: product,
          remote_file_url: product_pictures.sample,
          position: n
        })
      rescue
        retry unless (tries -= 1).zero?
      end
    end

    progressbar_photo_for_products.increment
  end

  product_categories = ProductCategory.published

  progressbar_photo_for_product_categories =
    ProgressBar.create({
      title: 'Create photos for product_categories',
      total: product_categories.size,
      format: '%t %B %p%% %e'
    })

  product_categories.find_each do |product_category|
    tries ||= 3
    begin
      Photo.create({
        photoable: product_category,
        remote_file_url: product_pictures.sample
      })
    rescue
      retry unless (tries -= 1).zero?
    end
    progressbar_photo_for_product_categories.increment
  end
end
