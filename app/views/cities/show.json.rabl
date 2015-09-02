object @city

attributes :id, :title

node :region_title do |city|
  @city.region_title
end
