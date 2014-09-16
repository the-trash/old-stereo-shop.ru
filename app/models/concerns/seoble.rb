module Seoble
  extend ActiveSupport::Concern

  included do
    hstore_accessor :meta,
      keywords: :string,
      title: :string,
      description: :string
  end
end
