class FrontController < ApplicationController
  before_filter :set_variables

  protected

  def set_variables
    @meta = {
      seo_title: 'Стерео шоп',
      keywords: 'Ключевики',
      seo_description: 'Описание'
    }

    @settings ||= $settings
  end
end
