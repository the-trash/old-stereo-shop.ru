class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file

  def store_dir
    "uploads/#{model.photoable_type.underscore}/#{model.id}"
  end

  def extension_white_list
    Settings.carrierwave.extension_white_list.photos
  end

  version :small do
    process resize_and_pad: [100, 100]
  end

  version :product, if: :is_product? do
    process resize_and_pad: [570, 370]

    version :thumb do
      process resize_and_pad: [70, 45]
    end

    version :related do
      process resize_and_pad: [170, 110]
    end

    version :similar do
      process resize_and_pad: [270, 175]
    end

    version :wishlist do
      process resize_and_pad: [170, 110]
    end
  end

  version :product_category, if: :is_product_category? do
    process resize_and_pad: [260, 115]
  end

  protected

  def is_product?(picture)
    ['Product', 'Product::AdditionalOption'].include? model.photoable_type
  end

  def is_product_category?(picture)
    model.photoable_type == 'ProductCategory'
  end
end
