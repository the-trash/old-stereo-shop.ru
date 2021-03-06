ActiveAdmin.register Product::ImportEntry do
  menu false

  belongs_to 'product/import',
    instance_name: :product_import,
    parent_class: Product::Import,
    param: :product_import_id,
    route_name: :product_import

  navigation_menu :default

  actions :index

  index do
    selectable_column
    column :id
    column :state
    column :data do |import_entry|
      content_tag :ul do
        import_entry.data.each do |key, value|
          val = value.nil? ? content_tag(:b, I18n.t('blank')) : value
          li = content_tag :li do
            "#{content_tag(:b, key)} - #{val}".html_safe
          end

          concat li
        end
      end
    end
    column :created_at do |import_entry|
      I18n.l(import_entry.created_at, format: :long)
    end
    column :import_errors do |import_entry|
      errors = import_entry.import_errors
      content_tag :ol, class: 'with-list-style' do
        errors.split("\n").each do |error_msg|
          concat content_tag :li, error_msg
        end
      end if errors.presence
    end
  end
end
