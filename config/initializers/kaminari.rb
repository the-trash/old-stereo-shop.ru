Kaminari.configure do |config|
  config.page_method_name = :per_page_kaminari
end

module ::Pagination::Base
  def self.per_method
    @per = :per_page_kaminari
  end
end
