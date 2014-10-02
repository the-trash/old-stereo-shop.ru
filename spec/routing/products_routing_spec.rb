describe 'routes for Products' do
  it 'GET /products' do
    expect(get: '/products').to route_to(controller: 'products', action: 'index')
  end

  it 'GET /products/:id' do
    expect(get: '/products/1').
      to route_to(controller: 'products', action: 'show', id: '1')
  end
end
