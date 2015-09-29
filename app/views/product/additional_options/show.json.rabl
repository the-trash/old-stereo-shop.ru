object @additional_option

attributes :id, :title, :render_type

child @photos => :photos do
  attributes :default

  node :big_thumbnail_url do |photo|
    ImageDecorator.decorate(@product).photo_url :product
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
