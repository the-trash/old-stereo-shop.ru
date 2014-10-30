class FrontController < ApplicationController
  before_filter :set_variables

  add_breadcrumb 'Главная', :root_path

  protected

  def set_variables
    @meta = {
      seo_title: 'Стерео шоп',
      keywords: 'Ключевики',
      seo_description: 'Описание'
    }

    @settings ||= $settings

    @product_categories = ProductCategory.for_front.arrange(order: :position)
  end

  def breadcrumbs_with_ancestors(obj, resource = nil)
    obj.ancestors.each do |parent_obj|
      add_breadcrumb parent_obj.title, parent_obj
    end

    add_breadcrumb obj.title, obj
    add_breadcrumb resource.title, resource if resource.present?
  end
end
