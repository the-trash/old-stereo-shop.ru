ABS_PATH = "#{Rails.root}/app/assets/images/default_images/"
DEFAULT_IMG = 'default-image.png'

namespace :photo_uploader do
  namespace :defaults do
    desc "Generates defaults images for carrierwave PhotoUploader"

    task :generate => :environment  do
      default = ABS_PATH + DEFAULT_IMG
      
      return unless File.exists? default

      file = Magick::Image::read(default).first

      PhotoUploader.versions.each do |name, val|
        uploader = val[:uploader]
        subversions = uploader.versions
        build_default(file, name, uploader)
        if subversions.any?
          subversions.each { |k, v| build_default file, "#{name}_#{k}", v[:uploader] }
        end
      end
    end

    def build_default(file, name, uploader)
      procs = uploader.processors.first
      
      # processors[0] is a name of processor method
      # processors[1] is an arguments (such as size)
      return if procs[0] != :resize_and_pad
      size = procs[1] # get size of version
      new_img = file.resize_to_fill procs[1][0], procs[1][1]
      if new_img.write "#{ABS_PATH}#{name}_#{DEFAULT_IMG}"
        p "DEFAULT IMG CREATED: #{new_img.filename}"
      end
    end
  end
end
