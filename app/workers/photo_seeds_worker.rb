class PhotoSeedsWorker
  include Sidekiq::Worker

  sidekiq_options retry: 5, unique: true, queue: :critical

  def perform(model)
    suckr = ImageSuckr::GoogleSuckr.new
    pictures =
      [].tap do |a|
        rand(40..60).times do |n|
          a << suckr.get_image_url({
              q: 'stereo&product',
              as_filetype: 'jpg',
              imgtype: 'photo',
              imgc: 'color'
            }
          )
        end
      end

    model.constantize.find_each do |obj|
      rand(2..4).times do |n|
          tries ||= 3
        begin
          Photo.create({
            photoable: obj,
            remote_file_url: pictures.sample,
            position: n
          })
        rescue
          retry unless (tries -= 1).zero?
        end
      end
    end
  end
end
