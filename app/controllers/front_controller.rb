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
  end

  def breadcrumbs_with_ancestors(obj)
    obj.ancestors.each do |parent_obj|
      add_breadcrumb parent_obj.title, parent_obj
    end

    add_breadcrumb obj.title, obj
  end
end
