class FrontController < ApplicationController
  before_filter :set_variables

  protected

  def set_variables
    @meta = {
      title: 'Стерео шоп',
      keywords: 'Ключевики',
      description: 'Описание'
    }

    @settings ||= $settings
  end
end