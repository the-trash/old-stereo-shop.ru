class FrontController < ApplicationController
  before_filter do
    @meta = {
      title: 'Стерео шоп',
      keywords: 'Ключевики',
      description: 'Описание'
    }

    @settings ||= $settings
  end
end