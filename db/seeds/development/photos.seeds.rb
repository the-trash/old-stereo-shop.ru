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
      begin
        Photo.create({
          photoable: product,
          remote_file_url: product_pictures.sample,
          position: n
        })
      rescue
        retry
      end
    end

    progressbar_photo_for_products.increment
  end
end
