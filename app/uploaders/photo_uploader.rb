class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file

  def store_dir
    "uploads/#{model.photoable_type.underscore}/#{model.id}"
  end

  version :small do
    process resize_to_fill: [100, 100]
  end

  version :product, if: :is_product? do
    process resize_to_fill: [570, 370]

    version :thumb do
      process resize_to_fill: [70, 45]
    end

    version :related do
      process resize_to_fill: [170, 110]
    end

    version :similar do
      process resize_to_fill: [270, 175]
    end

    version :wishlist do
      process resize_to_fill: [170, 110]
    end
  end

  version :product_category, if: :is_product_category? do
    process resize_to_fill: [260, 115]
  end

  protected

  def is_product?(picture)
    model.photoable_type == 'Product'
  end

  def is_product_category?(picture)
    model.photoable_type == 'ProductCategory'
  end
end
