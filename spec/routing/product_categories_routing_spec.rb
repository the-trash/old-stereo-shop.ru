describe 'routes for ProductCategories' do
  it 'GET product_categories/sale' do
    expect(get: '/product_categories/sale').to route_to(controller: 'product_categories', action: 'sale')
  end

  it 'GET /product_categories/:id' do
    expect(get: '/product_categories/1').
      to route_to(controller: 'product_categories', action: 'show', id: '1')
  end
end
