class ShopSitemap
  def add_links_with_pagination size, limit, &block
    ((size - 1) / limit).times do |n|
      yield n
    end
  end
end
