node :region_title do |city|
  @city.region_title
end

node(:id) { |city| @city.id }
node(:title) { |city| @city.title }
