module ActiveAdmin
  module Views
    module HasManyPhotos
      using Refinements::Array::Formatter

      def has_many_photos(opts = {})
        options = {
          has_many: {
            allow_destroy: true,
            heading: false,
            new_record: true
          },
          relashion: :photos,
          image_version: :small,
          as: :select2
        }.merge!(opts)

        has_many(options[:relashion], options[:has_many]) do |photo|
          photo.input :file, hint: photo.template.image_tag(photo.object.file_url(options[:image_version]))
          photo.input :state,
            as: options[:as],
            collection: photo.object.class.states.keys.map_with_state_locale,
            selected: photo.object.state
          photo.input :default
        end
      end
    end
  end
end

ActiveAdmin::FormBuilder.send(:include, ActiveAdmin::Views::HasManyPhotos)
