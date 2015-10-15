class ImageDecorator < Draper::Decorator
  delegate_all

  # Takes PhotoUploader versions
  # for method arguments
  def photo_url(*args)
    photo = object.photos.default
    photo ? photo.file.url(*args) : uploader_default_url(*args)
  end

  private

  def uploader_default_url(*args)
    PhotoUploader.new.url *args
  end
end
