# Pagination

Just Pagination conerns

> params => per_page | page

class Product < AR
  include ::Pagination::Base
end

@posts = Post.pagination(params)

span.mr40
  span.mr10 элементов на стр:
  - %w[ 5 10 20 50 100 125 ].each do |num|
    span.mr10= link_to num, url_for(per_page: num)

config/initializers/kaminari.rb

```
Kaminari.configure do |config|
  config.page_method_name = :per_page_kaminari
end

module ::Pagination::Base
  def self.per_method
    @per = :per_page_kaminari
  end
end
```