class FrontController < ApplicationController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_variables

  add_breadcrumb '', :root_path

  def after_sign_in_path_for(resource)
    session[:user] = {
      product_ids: []
    }
    super
  end

  def after_sign_out_path_for(resource)
    session[:user] = nil
    super
  end

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

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:city, :index, :address, :birthday, :phone, :email, :password, :password_confirmation)
    end
  end
end
