class FrontController < ApplicationController
  before_filter :set_variables

  add_breadcrumb '', :root_path

  protected

  def set_variables
    @meta = {
      seo_title: 'Стерео шоп',
      keywords: 'Ключевики',
      seo_description: 'Описание'
    }

    @settings ||= $settings

    # TODO: add cache
    @product_categories = ProductCategory.includes(:photos).for_front.arrange(order: :position)
    @news = PostCategory.find_by(title: I18n.t('news'))
    @useful_information = PostCategory.find_by(title: I18n.t('useful_information'))
  end

  def breadcrumbs_with_ancestors(obj, resource = nil)
    obj.ancestors.each do |parent_obj|
      add_breadcrumb parent_obj.title, parent_obj
    end

    add_breadcrumb obj.title, obj
    add_breadcrumb resource.title, resource if resource.present?
  end
end
