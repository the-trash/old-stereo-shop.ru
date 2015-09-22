module AdminApp
  module ApplicationHelper
    def preloader spinner_size_class = 'fa-4x'
      content_tag :div, class: 'l-preloader' do
        content_tag :i, nil, class: ['fa fa-spinner fa-spin', spinner_size_class].join(' ')
      end
    end
  end
end
