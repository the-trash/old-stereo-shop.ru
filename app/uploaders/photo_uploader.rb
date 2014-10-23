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
  end

  protected

  def is_product?(picture)
    model.photoable_type == 'Product'
  end
end
