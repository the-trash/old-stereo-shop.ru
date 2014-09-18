module Seoble
  extend ActiveSupport::Concern

  included do
    hstore_accessor :meta,
      keywords: :string,
      seo_title: :string,
      seo_description: :string
  end
end
