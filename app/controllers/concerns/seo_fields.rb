module SeoFields
  extend ActiveSupport::Concern

  included do
    before_filter :load_meta_data
  end

  protected

  def load_meta_data
    begin
      # If action has no resource founded by ID, 
      # it will raise active record error
      if resource.present?
        set_meta_tags title: resource.seo_title if resource.respond_to? :seo_title
        set_meta_tags description: resource.seo_description if resource.respond_to? :seo_description
        set_meta_tags keywords: resource.keywords if resource.respond_to? :keywords
      end
    rescue => e
      # try to load from DB 
      # It will works only if you create SeoSetting for it
      # Unless meta_tags will loads from I18n
      load_custom_meta_for_page
    end
  end

  def load_custom_meta_for_page
    meta = SeoSetting.find_by controller_name: controller_name,
                              action_name: action_name
    
    return unless meta.present?
    set_meta_tags title: meta.seo_title,
                  description: meta.seo_description,
                  keywords: meta.keywords
  end
end
