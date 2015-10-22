object @additional_option

attributes :id, :title, :render_type

child @photos => :photos do
  attributes :default

  node :big_thumbnail_url do |photo|
    if photo.default?
      ImageDecorator.decorate(@additional_option_value).photo_url :product
    else
      photo.file.url :product
    end
  end

  node :thumbnail_url do |photo|
    photo.file.url :product, :thumb
  end
end

child @product_attributes => :product_attributes do
  attributes :id, :state, :product_attribute
  attributes new_value: :value, additional_options_value_id: :option_id,
    product_attribute: :type
end
