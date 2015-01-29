class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file

  def extension_white_list
    Settings.carrierwave.extension_white_list.files
  end
end
